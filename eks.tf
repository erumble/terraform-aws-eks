module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name    = local.eks_cluster_name
  cluster_version = var.eks_cluster_version
  enable_irsa     = true

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  # This isn't actually necessary if there's only 1 node group.
  # It's just here as an example.
  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 20
  }

  node_groups = {
    workers = {
      min_capacity     = 0
      desired_capacity = 3
      max_capacity     = 6

      instance_types = ["t3.large", "t3a.large", "m5.large", "m5a.large"]
      capacity_type  = "SPOT"

      k8s_labels = {
        Environment = var.environment
      }
    }
  }

  map_roles = [
    {
      rolearn  = aws_iam_role.eks_admin.arn
      username = aws_iam_role.eks_admin.name
      groups   = ["system:masters"]
    }
  ]
}

resource "aws_iam_role" "eks_admin" {
  name               = join("-", [local.eks_cluster_name, "admin"])
  assume_role_policy = data.aws_iam_policy_document.eks_admin_arp.json
}

data "aws_iam_policy_document" "eks_admin_arp" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_iam_role_policy" "eks_admin" {
  name   = "view-all-eks-nodes-and-workloads"
  role   = aws_iam_role.eks_admin.id
  policy = data.aws_iam_policy_document.eks_admin.json
}

data "aws_iam_policy_document" "eks_admin" {
  statement {
    sid = "AllowViewNodesAndWorkloads"

    actions = [
      "eks:DescribeNodegroup",
      "eks:ListNodegroups",
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:AccessKubernetesApi",
      "ssm:GetParameter",
      "eks:ListUpdates",
      "eks:ListFargateProfiles"
    ]

    resources = ["*"]
  }
}
