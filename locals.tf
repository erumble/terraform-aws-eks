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

  # versions must start with `v` because https://github.com/hashicorp/terraform-provider-aws/blob/main/aws/resource_aws_eks_addon.go#L51
  eks_addon_versions = {
    coredns = {
      "1.20" = "v1.8.3"
      "1.19" = "v1.8.0"
      "1.18" = "v1.7.0"
      "1.17" = "v1.6.6"
    }
    kube_proxy = {
      "1.20" = "v1.20.4-eksbuild.2"
      "1.19" = "v1.19.6-eksbuild.2"
      "1.18" = "v1.18.8-eksbuild.1"
      "1.17" = "v1.17.9-eksbuild.1"
    },
    vpc_cni = {
      "1.20" = "v1.7"
      "1.19" = "v1.7"
      "1.18" = "v1.7"
      "1.17" = "v1.7"
    },
  }
}
