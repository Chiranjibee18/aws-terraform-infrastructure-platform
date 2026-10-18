variable "environment" {
  type        = string
  description = "Target deployment environment"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups will be attached"
}
