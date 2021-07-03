variable "aws_provider_role_arn" {
  description = "The Role ARN the AWS provider will assume to create resources with."
  type        = string
}

variable "aws_provider_external_id" {
  description = "The External ID to use when the provider assumes the given IAM role."
}

variable "environment" {
  description = "The name of the environment being created. Taggable resources will include this in their `Environment` tag."
  type        = string
}

variable "resource_prefix" {
  description = "String to prepend to any resource names."
  type        = string
  default     = ""
}

variable "vpc_azs" {
  description = "A list of availability zones names in the region (Only the letter suffix, the region will be prepended via a data source)."
  type        = list(string)
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "vpc_enable_ipv6" {
  description = "Set to true to associate an IPv6 address space with the VPC."
  type        = bool
  default     = false
}

variable "vpc_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks."
  type        = bool
  default     = true
}

variable "vpc_one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.vpc_azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.vpc_azs`."
  type        = bool
  default     = true
}

variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC."
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "A list of public subnets inside the VPC."
  type        = list(string)
}

variable "vpc_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks."
  type        = bool
  default     = false
}
