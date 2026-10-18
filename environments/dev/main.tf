terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote State configuration with DynamoDB state locking
  # backend "s3" {
  #   bucket         = "chiranjibee-terraform-state-654654375398"
  #   key            = "dev/terraform.tfstate"
  #   region         = "ap-south-1"
  #   dynamodb_table = "terraform-state-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "CloudInfrastructurePlatform"
      Environment = var.environment
      Owner       = "Chiranjibee Panigrahi"
      ManagedBy   = "Terraform"
    }
  }
}

module "vpc" {
  source = "../../modules/vpc"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security" {
  source = "../../modules/security"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

module "iam" {
  source = "../../modules/iam"

  environment = var.environment
}

module "storage" {
  source = "../../modules/storage"

  environment = var.environment
  account_id  = var.account_id
}

module "compute" {
  source = "../../modules/compute"

  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  public_subnet_ids         = module.vpc.public_subnet_ids
  private_subnet_ids        = module.vpc.private_subnet_ids
  alb_security_group_id     = module.security.alb_security_group_id
  app_security_group_id     = module.security.app_security_group_id
  iam_instance_profile_name = module.iam.instance_profile_name
  instance_type             = var.instance_type
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
}
