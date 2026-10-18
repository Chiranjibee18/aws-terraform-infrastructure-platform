output "alb_security_group_id" {
  description = "ID of the Application Load Balancer security group"
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "ID of the application compute security group"
  value       = aws_security_group.app.id
}
