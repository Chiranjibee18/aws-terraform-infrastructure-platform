variable "environment" {
  type        = string
  description = "Target deployment environment (dev, staging, prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "Base IPv4 CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDR ranges"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDR ranges"
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to distribute subnets across"
  default     = ["ap-south-1a", "ap-south-1b"]
}
