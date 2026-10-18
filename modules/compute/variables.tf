variable "environment" {
  type        = string
  description = "Target deployment environment"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where resources are deployed"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for Application Load Balancer"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for Auto Scaling instances"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security Group ID for ALB"
}

variable "app_security_group_id" {
  type        = string
  description = "Security Group ID for compute instances"
}

variable "iam_instance_profile_name" {
  type        = string
  description = "IAM instance profile name for SSM access"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "min_size" {
  type        = number
  description = "Minimum size of Auto Scaling Group"
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Maximum size of Auto Scaling Group"
  default     = 6
}

variable "desired_capacity" {
  type        = number
  description = "Desired capacity of Auto Scaling Group"
  default     = 2
}
