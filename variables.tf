# variables.tf - Root variables for AskHeyStupid

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "askheystupid"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "domain_name" {
  description = "Custom domain name (optional)"
  type        = string
  default     = null
}

# Security-related variables
variable "enable_waf" {
  description = "Enable WAF protection on CloudFront"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Retention period for CloudWatch logs in days"
  type        = number
  default     = 30
}

variable "bedrock_model_id" {
  description = "Bedrock model ID to use"
  type        = string
  default     = "us.anthropic.claude-haiku-4-5-20251001-v1:0"
}

variable "enable_aws_config" {
  description = "Enable AWS Config recorder (set to false if you already have one)"
  type        = bool
  default     = false
}
