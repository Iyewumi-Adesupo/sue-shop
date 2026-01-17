# Creating EC2 instance for webserver
resource "aws_instance" "sueshop-webserver" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  associate_public_ip_address = true
  key_name                    = var.key_name

  vpc_security_group_ids = var.security_group_ids

  user_data = var.user_data

  tags = {
    Name        = "sueshop-webserver"
    Environment = var.environment
  }
}

#Creating an EC2 keypair
resource "aws_key_pair" "sueshop_keypair" {
  key_name   = var.key_name
  public_key = file(var.public_keypair_path)

  tags = {
    Name = var.sueshop_keypair
  }
}

# Creating Launch template for webserver
resource "aws_launch_template" "sueshop-lt" {
  name_prefix   = "sueshop-web"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group_ids

  user_data = base64encode(file("${path.module}/user_data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "sueshop-lt"
      Environment = var.environment
    }
  }
}

# Creating ASG for instance
resource "aws_autoscaling_group" "sueshop-asg" {
  name                = "sue-shop-asg"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2

  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns  = var.target_group_arns

  launch_template {
    id      = aws_launch_template.sueshop-lt.id
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