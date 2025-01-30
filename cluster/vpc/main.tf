module "vpc" {
  source                 = "squareops/vpc/aws"
  name                   = var.name
  vpc_cidr               = var.vpc_cidr
  environment            = var.environment
  availability_zones     = var.availability_zones
  public_subnet_enabled  = true
  private_subnet_enabled = true
}
