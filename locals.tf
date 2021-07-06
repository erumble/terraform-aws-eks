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

  eks_addon_versions = {
    coredns = {
      "1.20" = "1.8.3"
      "1.19" = "1.8.0"
      "1.18" = "1.7.0"
      "1.17" = "1.6.6"
    }
    kube_proxy = {
      "1.20" = "1.20.4-eksbuild.2"
      "1.19" = "1.19.6-eksbuild.2"
      "1.18" = "1.18.8-eksbuild.1"
      "1.17" = "1.17.9-eksbuild.1"
    },
    vpc_cni = {
      "1.20" = "1.7"
      "1.19" = "1.7"
      "1.18" = "1.7"
      "1.17" = "1.7"
    },
  }
}
