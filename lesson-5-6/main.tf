module "vpc" {
  source          = "./vpc"
  project_name    = var.project_name
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "eks" {
  source          = "./eks"
  project_name    = var.project_name

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}