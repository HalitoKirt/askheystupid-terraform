variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL from security module"
  type        = string
  nullable    = true
}

variable "api_gateway_url" {
  description = "API Gateway invoke URL for CloudFront origin"
  type        = string
}
