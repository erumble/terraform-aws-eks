locals {
  resource_prefix = var.resource_prefix == null ? "" : "${var.resource_prefix}-"

  vpc_azs = formatlist("%s%s", data.aws_region.current.name, var.vpc_azs)
}