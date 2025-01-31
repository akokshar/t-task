data "aws_caller_identity" "this" {}

module "key_pair_eks" {
  source             = "squareops/keypair/aws"
  version            = "1.0.2"
  key_name           = format("%s-%s-eks", var.environment, var.name)
  environment        = var.environment
  ssm_parameter_path = format("%s-%s-eks", var.environment, var.name)
}

module "eks" {
  source  = "squareops/eks/aws"
  version = "5.2.1"

  #access_entry_enabled = true
  #access_entries = {
  #  "example" = {
  #    kubernetes_groups = []
  #    principal_arn     = "arn:aws:iam::0000000000:user/alexander.koksharov"
  #    policy_associations = {
  #      example = {
  #        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  #        access_scope = {
  #          namespaces = []
  #          type       = "cluster"
  #        }
  #      }
  #    }
  #  }
  #}

  enable_cluster_creator_admin_permissions = true

  name            = var.name
  cluster_version = var.cluster_version
  environment     = var.environment

  vpc_id                 = var.vpc_id
  vpc_private_subnet_ids = var.subnets_ids

  kms_key_arn = module.kms.key_arn

  cluster_log_types             = []
  cluster_log_retention_in_days = 1

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access

  nodes_keypair_name = module.key_pair_eks.key_pair_name

  tags = var.additional_tags
}

resource "aws_iam_instance_profile" "default_instance_profile" {
  role        = module.eks.worker_iam_role_name
  name_prefix = module.eks.cluster_name
  tags = {
    "Name" = format("%s-%s-default-instance-profile", var.environment, var.name)
  }
}

resource "aws_eks_addon" "pod_identity" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "eks-pod-identity-agent"
  resolve_conflicts_on_update = "OVERWRITE"
}

module "managed_node_group_cluster" {
  source  = "squareops/eks/aws//modules/managed-nodegroup"
  version = "5.2.1"

  depends_on = [module.eks]

  eks_cluster_name = module.eks.cluster_name
  environment      = var.environment

  managed_ng_name         = "cluster"
  managed_ng_min_size     = 2
  managed_ng_max_size     = 2
  managed_ng_desired_size = 2

  vpc_subnet_ids = var.subnets_ids

  managed_ng_capacity_type    = var.managed_ng_capacity_type
  managed_ng_instance_types   = var.managed_ng_instance_types
  managed_ng_ebs_volume_size  = var.ebs_volume_size
  managed_ng_ebs_volume_type  = "gp3"
  managed_ng_ebs_encrypted    = false
  aws_managed_node_group_arch = var.aws_managed_node_group_arch
  #managed_ng_kms_key_arn        = module.kms.key_arn
  #managed_ng_kms_policy_arn     = module.eks.kms_policy_arn

  worker_iam_role_name   = module.eks.worker_iam_role_name
  worker_iam_role_arn    = module.eks.worker_iam_role_arn
  eks_nodes_keypair_name = module.key_pair_eks.key_pair_name


  launch_template_name = format("%s-%s-eks", var.environment, var.name)

  k8s_labels = {
    "eks-nodegroup" = "cluster"
  }

  tags = var.additional_tags
}
