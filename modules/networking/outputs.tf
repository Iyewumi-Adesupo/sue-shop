output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.sueshop_alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.sueshop_alb.dns_name
}

output "alb_zone_id" {
  description = "Route53 zone ID of the Application Load Balancer"
  value       = aws_lb.sueshop_alb.zone_id
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate used by the ALB"
  value       = aws_acm_certificate.sueshop_acm.arn
}

output "route53_record_fqdns" {
  description = "FQDNs for ACM DNS validation records"
  value       = [for r in aws_route53_record.sueshop_route53 : r.fqdn]
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "target_group_arn" {
  value = aws_lb_target_group.sueshop_tg.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}
output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = aws_route_table.private.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.ngw.id
}