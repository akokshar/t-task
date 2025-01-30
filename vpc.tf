module "vpc" {
  source                 = "squareops/vpc/aws"
  name                   = local.name
  vpc_cidr               = local.vpc_cidr
  environment            = local.environment
  availability_zones     = local.availability_zones
  public_subnet_enabled  = true
  private_subnet_enabled = true
}
