

resource "aws_eks_cluster" "eks-cluster" {
    name     = var.cluster-name
    role_arn = aws_iam_role.eks-cluster-role.arn

    version  = var.eks-version

    vpc_config {
        subnet_ids = aws_subnet.eks-cluster-subnets.*.id
        endpoint_public_access = true
    }
}

resource "aws_eks_node_group" "managed-node-group" {
    cluster_name    = aws_eks_cluster.eks-cluster.name
    node_group_name = "managed-node-group"
    node_role_arn   = aws_iam_role.eks-worker-node-role.arn
    subnet_ids      = aws_subnet.eks-cluster-subnets.*.id

    scaling_config {
        desired_size = 3
        min_size     = 3
        max_size     = 3
    }
}
