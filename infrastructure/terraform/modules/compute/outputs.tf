output "launch_template_id" {
  description = "Launch Template ID for the web server"
  value       = aws_launch_template.sueshop_lt.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.sueshop_asg.name
}

output "ec2_security_group_id" {
  description = "EC2 security group ID"
  value       = aws_security_group.ec2_sg.id
}
