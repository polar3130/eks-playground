data "aws_availability_zones" "available-zone" {
  state = "available"
}

resource "aws_vpc" "eks-cluster-vpc" {
  cidr_block = var.vpc-cidr-block
}

resource "aws_subnet" "eks-cluster-subnets" {
  count = length(data.aws_availability_zones.available-zone.zone_ids)

  availability_zone = data.aws_availability_zones.available-zone.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.eks-cluster-vpc.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.eks-cluster-vpc.id

  map_public_ip_on_launch = true
  
  tags = {
      "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.eks-cluster-vpc.id
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.eks-cluster-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
}

resource "aws_route_table_association" "route-table-associations" {
  count = length(data.aws_availability_zones.available-zone.zone_ids)

  subnet_id = element(aws_subnet.eks-cluster-subnets.*.id, count.index)
  route_table_id = aws_route_table.route-table.id
}
