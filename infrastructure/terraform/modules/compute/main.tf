# Creating Launch template for webserver
resource "aws_launch_template" "sueshop_lt" {
  name_prefix   = "sueshop-web"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(file("${path.module}/user_data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "sueshop-web"
      Environment = var.environment
      SSMAccess   = "true"
    }
  }
}

# Creating ASG for instance
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
    key                 = "Name"
    value               = "sueshop-asg"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "sueshop-ec2-sg"
  description = "Security group for SueShop EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sueshop-ec2-sg"
  }
}