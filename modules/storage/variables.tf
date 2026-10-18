variable "environment" {
  type        = string
  description = "Target deployment environment"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID to ensure global uniqueness of S3 bucket names"
  default     = "654654375398"
}
