# modules/logging/main.tf
# Centralized logging bucket + CloudWatch setup
resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-tf-logs-${var.environment}-${random_string.suffix.result}"

  tags = {
    Name        = "${var.project_name}-central-logs"
    Environment = var.environment
    Purpose     = "Centralized access and audit logs"
  }
}


resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudWatch Log Group for Lambda and API Gateway
resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/${var.project_name}/${var.environment}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-application-logs"
    Environment = var.environment
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
