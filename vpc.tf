module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = "${local.resource_prefix}eks-vpc"
  cidr = var.vpc_cidr

  enable_ipv6            = var.vpc_enable_ipv6
  enable_nat_gateway     = var.vpc_enable_nat_gateway
  single_nat_gateway     = var.vpc_single_nat_gateway
  one_nat_gateway_per_az = var.vpc_one_nat_gateway_per_az

  azs = local.vpc_azs

  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
}
