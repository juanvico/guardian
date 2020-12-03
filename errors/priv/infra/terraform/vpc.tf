###### VPC

locals {
  vpc_name = "${var.app_name}-${var.app_env}-vpc"
}

# ### Create the VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = var.cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = var.app_env
    Name        = local.vpc_name
  }
}
