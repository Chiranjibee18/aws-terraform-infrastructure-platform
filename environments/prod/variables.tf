variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
  default     = "ap-south-1"
}

variable "environment" {
  type        = string
  description = "Environment identifier"
  default     = "prod"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID"
  default     = "654654375398"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for production VPC (isolated non-overlapping range)"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs across Availability Zones"
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs across Availability Zones"
  default     = ["10.1.11.0/24", "10.1.12.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for high availability"
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for production workloads"
  default     = "t3.small"
}

variable "min_size" {
  type        = number
  description = "Minimum capacity for production Auto Scaling Group"
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Maximum capacity for production Auto Scaling Group"
  default     = 6
}

variable "desired_capacity" {
  type        = number
  description = "Desired capacity for production Auto Scaling Group"
  default     = 3
}
