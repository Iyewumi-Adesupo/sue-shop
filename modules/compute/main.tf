# Launch Template for ASG instances
resource "aws_launch_template" "sueshop_lt" {
  name_prefix   = "sueshop-web"
  image_id      = var.ami_id
  instance_type = var.instance_type

  # SSH key for bastion → private instances
  key_name = var.ssh_key_name

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  vpc_security_group_ids = [var.ec2_security_group_id]

  user_data = base64encode(file("${path.module}/user_data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "sueshop-web"
      Role        = "web"
      Environment = var.environment
    }
  }
}

# Auto Scaling Group (PRIVATE subnets)
resource "aws_autoscaling_group" "sueshop_asg" {
  name             = "sue-shop-asg"
  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = var.target_group_arns

  launch_template {
    id      = aws_launch_template.sueshop_lt.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Role"
    value               = "web"
    propagate_at_launch = true
  }
}