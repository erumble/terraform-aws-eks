# Add non-secret workspace specific variable values here
environment     = "production"
resource_prefix = "prod"

vpc_azs = ["a", "b", "c"]

vpc_cidr = "10.20.0.0/16"

vpc_private_subnets = [
  "10.20.16.0/20",
  "10.20.32.0/20",
  "10.20.48.0/20",
]

vpc_public_subnets = [
  "10.20.0.0/24",
  "10.20.1.0/24",
  "10.20.2.0/24",
]
