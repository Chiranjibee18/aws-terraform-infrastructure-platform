output "alb_public_url" {
  description = "Public URL to access the Application Load Balancer"
  value       = "http://${module.compute.alb_dns_name}"
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "nat_gateway_ip" {
  description = "Egress NAT Gateway public IP"
  value       = module.vpc.nat_gateway_ip
}

output "s3_assets_bucket" {
  description = "Encrypted S3 bucket for application assets"
  value       = module.storage.bucket_id
}
