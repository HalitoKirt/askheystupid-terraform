output "logs_bucket_id" {
  description = "ID of the centralized logging S3 bucket"
  value       = aws_s3_bucket.logs.id
}

output "logs_bucket_arn" {
  description = "ARN of the centralized logging S3 bucket"
  value       = aws_s3_bucket.logs.arn
}

output "application_log_group_name" {
  description = "Name of the main CloudWatch log group"
  value       = aws_cloudwatch_log_group.application.name
}

output "application_log_group_arn" {
  description = "ARN of the main CloudWatch log group"
  value       = aws_cloudwatch_log_group.application.arn
}
