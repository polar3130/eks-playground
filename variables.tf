variable "eks-playaground-region" {
    default = "ap-northeast-1"
}

variable "cluster-name" {
    default = "my-eks-cluster"
}

variable "vpc-cidr-block" {
    default = "10.0.0.0/16"
}
variable "eks-version" {
    default = "1.15"
}
