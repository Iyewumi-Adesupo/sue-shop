output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.sueshop-alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.sueshop-alb.dns_name
}

output "alb_zone_id" {
  description = "Route53 zone ID of the Application Load Balancer"
  value       = aws_lb.sueshop-alb.zone_id
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate used by the ALB"
  value       = aws_acm_certificate.sueshop_acm.arn
}

output "route53_record_fqdn" {
  description = "Fully qualified domain name for the ALB Route53 record"
  value       = aws_route53_record.sueshop_route53.fqdn
}

output "public_subnet_id" {
  value = aws_subnet.public-subnet-1.id
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id
  ]
}

output "target_group_arn" {
  value = aws_lb_target_group.sueshop-tg.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}