terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  default_tags {
    tags = merge(
      var.tags,
      {
        Environment = var.environment
        Project     = var.project
      }
    )
  }
}

# Secrets Manager for storing sensitive information
resource "aws_secretsmanager_secret" "main" {
  name = "${var.project}-${var.environment}-secrets"
  description = "Secrets for ${var.project} ${var.environment} environment"

  tags = {
    Name        = "${var.project}-${var.environment}-secrets"
    Environment = var.environment
  }
}

# Initial secret version with basic information
resource "aws_secretsmanager_secret_version" "initial" {
  secret_id = aws_secretsmanager_secret.main.id
  secret_string = jsonencode({
    project     = var.project
    environment = var.environment
    openai_api_key = var.openai_api_key
    created_at  = timestamp()
    initial_setup = "completed"
  })
}

# IAM Module
module "iam" {
  source = "../../modules/iam"

  project     = var.project
  environment = var.environment
}

# EC2 Module
module "ec2" {
  source = "../../modules/ec2"

  project     = var.project
  environment = var.environment
  iam_role_arn = module.iam.ec2_role_arn
}
