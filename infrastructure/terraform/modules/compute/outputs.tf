output "ec2_instance_id" {
  description = "ID of the standalone EC2 web server"
  value       = aws_instance.sueshop-webserver.id
}

output "ec2_public_ip" {
  description = "Public IP of the standalone EC2 web server"
  value       = aws_instance.sueshop-webserver.public_ip
}

output "launch_template_id" {
  description = "Launch Template ID for the web server"
  value       = aws_launch_template.sueshop-lt.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.sueshop-asg.name
}