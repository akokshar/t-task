module "vpc" {
  source = "./vpc"

  name               = local.name
  environment        = local.environment
  availability_zones = local.availability_zones
  vpc_cidr           = local.vpc_cidr
}

module "eks" {
  source = "./eks"

  depends_on = [ module.vpc ]

  name            = local.name
  environment     = local.environment
  cluster_version = local.cluster_version

  aws_region = local.region

  vpc_id      = module.vpc.vpc_id
  subnets_ids = module.vpc.private_subnets_ids

  managed_ng_capacity_type  = local.managed_ng_capacity_type
  managed_ng_instance_types = local.managed_ng_instance_types
  aws_managed_node_group_arch = local.aws_managed_node_group_arch
  ebs_volume_size           = local.ebs_volume_size

  cluster_endpoint_public_access       = local.cluster_endpoint_public_access
  cluster_endpoint_private_access      = local.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs = local.cluster_endpoint_public_access_cidrs

  additional_tags = local.additional_aws_tags
}

module "karpenter" {
  source = "./karpenter"
 
  depends_on = [ module.eks ]

  name = local.name
  environment = local.environment

  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.endpoint
  namespace = "karpenter"

  worker_iam_role_arn = module.eks.worker_iam_role_arn
  instance_profile_name = module.eks.instance_profile_name
}
