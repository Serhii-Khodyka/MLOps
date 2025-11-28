module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"
  name = var.project_name
  cidr = var.vpc_cidr
  azs = var.azs
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  enable_nat_gateway = true
}
