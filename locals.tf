locals {
  name        = "alex"
  region      = "us-east-1"
  environment = "test"
  additional_aws_tags = {
    Owner = "Alex"
  }
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]

  cluster_version = "1.31"

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  cluster_endpoint_private_access      = true

  managed_ng_capacity_type  = "SPOT"
  managed_ng_instance_types = ["m8g.medium"] # Smallest graviton instance
  ebs_volume_size           = 50
  launch_template_name      = format("launch-template-%s-%s", local.environment, local.name)
}

