output "launch_template_id" {
  description = "Launch Template ID for the web server"
  value       = aws_launch_template.sueshop_lt.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.sueshop_asg.name
}

