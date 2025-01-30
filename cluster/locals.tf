locals {
  name        = "alex"
  region      = "eu-west-2"
  environment = "test"
  additional_aws_tags = {
    Owner = "Alex"
  }
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["eu-west-2a", "eu-west-2b"]

  cluster_version = "1.32"

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  cluster_endpoint_private_access      = true

  managed_ng_capacity_type  = "SPOT"
  managed_ng_instance_types = ["t4g.medium"] # Smallest graviton instance
  aws_managed_node_group_arch = "arm64"
  ebs_volume_size           = 50
}

