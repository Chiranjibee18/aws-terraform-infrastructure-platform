resource "aws_s3_bucket" "assets" {
  bucket        = "${var.environment}-app-assets-${var.account_id}"
  force_destroy = true

  tags = {
    Name        = "${var.environment}-app-assets"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.assets.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enforce S3 Public Access Block for security compliance
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
