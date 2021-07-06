# This file contains provider configuration
# Provider version and source info can be found in versions.tf

# AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY are set by env vars
# 
# Note: The IAM _user_ that the access keys belong to should have read/write access
#       to the state file and the dynamodb lock table. The IAM _role_ should have
#       read/write access to any resources the TF configuration needs to manage.
#       Obviously, the user will also need permissions to assume the role.
provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn    = var.aws_provider_role_arn
    external_id = var.aws_provider_external_id
  }

  default_tags {
    tags = {
      Environment = var.environment
      TFWorkspace = terraform.workspace
      ManagedBy   = "Terraform"
      Source      = "https://github.com/erumble/tf-eks"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# Kubernetes provider configuration depends on the EKS module
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
