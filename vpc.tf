#provider "aws" {
#  region = var.aws_region
#}

data "aws_availability_zones" "available" {
  state = "available"
  exclude_names = [ var.aws_exclude_names ]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-jmeter-vpc"
  cidr = var.aws_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs
  map_public_ip_on_launch = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}