module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "20.17.0"

  cluster_name    = "${var.project_name}-cluster"
  cluster_version = "1.30"

  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_endpoint_public_access_cidrs = [
    "79.110.134.144/32"
  ]

  eks_managed_node_groups = {
    cpu_nodes = {
      instance_types = ["t3.micro"]
      desired_size   = 2
      max_size       = 3
      min_size       = 1
    }
  }
}
