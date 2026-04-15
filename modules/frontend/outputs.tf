output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.main.domain_name
}

output "website_bucket_id" {
  value = aws_s3_bucket.website.id
}
