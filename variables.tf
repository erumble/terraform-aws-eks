variable "aws_provider_role_arn" {
  description = "The Role ARN the AWS provider will assume to create resources with."
  type        = string
}

variable "aws_provider_external_id" {
  description = "The External ID to use when the provider assumes the given IAM role."
}
