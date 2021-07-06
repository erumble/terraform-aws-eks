resource "random_pet" "eks_cluster_name" {
  length    = 2
  separator = "-"

  keepers = {
    # Create a new cluster name when var.eks_cluster_name_revision is updated
    revision = var.eks_cluster_name_revision
  }
}

locals {
  eks_cluster_name = join("-", [var.resource_prefix, random_pet.eks_cluster_name.id])
  vpc_azs          = formatlist("%s%s", data.aws_region.current.name, var.vpc_azs)
  vpc_name         = join("-", [var.resource_prefix, "eks-vpc"])
}
