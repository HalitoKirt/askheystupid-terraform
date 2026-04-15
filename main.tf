# main.tf - Root module for AskHeyStupid
# Security-first Terraform deployment

terraform {
  required_version = ">= 1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Provider for us-east-1 (required for CloudFront WAF)
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# =============================================
# Logging Module
# =============================================
module "logging" {
  source = "./modules/logging"

  project_name       = var.project_name
  environment        = var.environment
  log_retention_days = var.log_retention_days
}

# =============================================
# Security Module
# =============================================
module "security" {
  source = "./modules/security"

  project_name     = var.project_name
  environment      = var.environment
  bedrock_model_id = var.bedrock_model_id

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }
}

# =============================================
# Frontend Module (S3 + CloudFront + WAF)
# =============================================
module "frontend" {
  source = "./modules/frontend"

  project_name    = var.project_name
  environment     = var.environment
  waf_web_acl_arn = module.security.waf_web_acl_arn
  api_gateway_url = module.backend.api_gateway_url
}

# =============================================
# Backend Module (Lambda + API Gateway)
# =============================================
module "backend" {
  source = "./modules/backend"

  project_name              = var.project_name
  environment               = var.environment
  lambda_role_arn           = module.security.lambda_role_arn
  application_log_group_arn = module.logging.application_log_group_arn
}

# =============================================
# Outputs
# =============================================
output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name (new Terraform version)"
  value       = module.frontend.cloudfront_domain_name
}

output "api_gateway_url" {
  description = "API Gateway endpoint URL"
  value       = module.backend.api_gateway_url
}

output "website_bucket_id" {
  description = "S3 bucket for the frontend website"
  value       = module.frontend.website_bucket_id
}

output "logs_bucket_id" {
  description = "Centralized logging S3 bucket"
  value       = module.logging.logs_bucket_id
}

output "lambda_function_name" {
  description = "Name of the backend Lambda function"
  value       = module.backend.lambda_function_name
}
