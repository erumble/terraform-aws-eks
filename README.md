# Terraform an EKS cluster

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_provider_external_id"></a> [aws\_provider\_external\_id](#input\_aws\_provider\_external\_id) | The External ID to use when the provider assumes the given IAM role. | `any` | n/a | yes |
| <a name="input_aws_provider_role_arn"></a> [aws\_provider\_role\_arn](#input\_aws\_provider\_role\_arn) | The Role ARN the AWS provider will assume to create resources with. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment being created. Taggable resources will include this in their `Environment` tag. | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | String to prepend to any resource names. | `string` | `""` | no |
| <a name="input_vpc_azs"></a> [vpc\_azs](#input\_vpc\_azs) | A list of availability zones names in the region (Only the letter suffix, the region will be prepended via a data source). | `list(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block for the VPC. | `string` | n/a | yes |
| <a name="input_vpc_enable_ipv6"></a> [vpc\_enable\_ipv6](#input\_vpc\_enable\_ipv6) | Set to true to associate an IPv6 address space with the VPC. | `bool` | `false` | no |
| <a name="input_vpc_enable_nat_gateway"></a> [vpc\_enable\_nat\_gateway](#input\_vpc\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks. | `bool` | `true` | no |
| <a name="input_vpc_one_nat_gateway_per_az"></a> [vpc\_one\_nat\_gateway\_per\_az](#input\_vpc\_one\_nat\_gateway\_per\_az) | Should be true if you want only one NAT Gateway per availability zone. Requires `var.vpc_azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.vpc_azs`. | `bool` | `true` | no |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | A list of private subnets inside the VPC. | `list(string)` | n/a | yes |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | A list of public subnets inside the VPC. | `list(string)` | n/a | yes |
| <a name="input_vpc_single_nat_gateway"></a> [vpc\_single\_nat\_gateway](#input\_vpc\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks. | `bool` | `false` | no |

## Outputs

No outputs.
