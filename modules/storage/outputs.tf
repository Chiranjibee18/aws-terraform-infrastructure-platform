output "bucket_id" {
  description = "Name/ID of the provisioned S3 bucket"
  value       = aws_s3_bucket.assets.id
}

output "bucket_arn" {
  description = "ARN of the provisioned S3 bucket"
  value       = aws_s3_bucket.assets.arn
}
