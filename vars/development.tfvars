# Add non-secret workspace specific variable values here
environment         = "development"
eks_cluster_version = "1.20"
resource_prefix     = "dev"

vpc_azs  = ["a", "b", "c"]
vpc_cidr = "10.10.0.0/16"

vpc_private_subnets = [
  "10.10.16.0/20",
  "10.10.32.0/20",
  "10.10.48.0/20",
]

vpc_public_subnets = [
  "10.10.0.0/24",
  "10.10.1.0/24",
  "10.10.2.0/24",
]
