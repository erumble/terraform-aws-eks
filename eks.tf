# A note on the way the EKS cluster is configured:
# All the worker nodes should be in private subnets, so the AWS VPC CNI needs to be configured
# to use an external SNAT. This is done by setting the env var `AWS_VPC_K8S_CNI_EXTERNALSNAT=true`
# for the VPC CNI (aws-node). See https://docs.aws.amazon.com/eks/latest/userguide/external-snat.html
# for more details.

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name     = local.eks_cluster_name
  cluster_version  = var.eks_cluster_version
  enable_irsa      = true
  write_kubeconfig = false

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

# EKS Addons (see https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html)

# The vpc-cni addon requires special permissions, so it gets its own IAM role
# See https://docs.aws.amazon.com/eks/latest/userguide/cni-iam-role.html for more info
# Also, the service name for the vpn-cni is `aws-node`, because reasons
resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = module.eks.cluster_id
  addon_name               = "vpc-cni"
  addon_version            = local.eks_addon_versions.vpc_cni[var.eks_cluster_version]
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = aws_iam_role.vpc_cni.arn
}

resource "aws_iam_role" "vpc_cni" {
  assume_role_policy = data.aws_iam_policy_document.vpc_cni_arp.json
  name               = join("-", [local.eks_cluster_name, "vpc-cni-role"])
}

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni.name
}

data "aws_iam_policy_document" "vpc_cni_arp" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"] # aws-node is the service name
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = module.eks.cluster_id
  addon_name        = "kube-proxy"
  addon_version     = local.eks_addon_versions.kube_proxy[var.eks_cluster_version]
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = module.eks.cluster_id
  addon_name        = "coredns"
  addon_version     = local.eks_addon_versions.coredns[var.eks_cluster_version]
  resolve_conflicts = "OVERWRITE"
}


# IAM role to grant access via kubectl
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
