# output "webapp_public_ips" {
#   value = aws_instance.webapp.public_ip
# }

output "target_group_arn" {
  value = aws_lb_target_group.webapp.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.web_alb.dns_name
}

# output "instance_id" {
#   description = "ID of the EC2 instance"
#   value       = aws_instance.roger_web.id
# }