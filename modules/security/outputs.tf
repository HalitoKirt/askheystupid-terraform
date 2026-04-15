output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_role.arn
}

output "waf_web_acl_arn" {
  description = "WAF Web ACL ARN for CloudFront"
  value       = aws_wafv2_web_acl.cloudfront.arn
}
