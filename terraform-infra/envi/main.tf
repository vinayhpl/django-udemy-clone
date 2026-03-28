provider "aws" {
  region = var.region
}

module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "ec2" {
  source = "../modules/ec2"

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_id

  ami_id   = var.ami_id
  key_name = var.key_name

  common_tags = {
    Environment = "dev"
    Project     = "tummoc-assignment"
    Owner       = "vinays"
  }
}