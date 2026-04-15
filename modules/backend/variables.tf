variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the Lambda execution role from security module"
  type        = string
}

variable "application_log_group_arn" {
  description = "ARN of the CloudWatch log group from logging module"
  type        = string
}
