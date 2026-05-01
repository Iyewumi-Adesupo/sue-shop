
resource "aws_security_group" "rds_sg" {
  name        = "sueshop-rds-sg"
  description = "RDS security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sueshop-rds-sg"
  }
}

# IAM for EC2
resource "aws_iam_role" "ec2_role" {
  name = "sueshop-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "sueshop-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Secrets Manager (DB Credentials)
resource "aws_secretsmanager_secret" "db_secret" {
  name = "sueshop/db/credentials"
}

resource "random_password" "db_password" {
  length           = 24
  special          = true
  override_special = "!@#$%^&*()-_=+[]{}"
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({
    db_username = var.db_username
    db_password = random_password.db_password.result
    database    = var.db_name
  })
}

# Creating Bastion Host SG
resource "aws_security_group" "bastion_sg" {
  name        = "sueshop-bastion-sg"
  description = "Security group for SueShop Bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow SSH from admin IPv6 CIDR"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = [var.admin_ipv6_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sueshop-bastion-sg"
  }
}

# Public-Keypair
resource "aws_key_pair" "bastion" {
  key_name   = "sueshop-bastion-key"
  public_key = file("~/.ssh/sueshop-bastion.pub")
}

# Security Group for EC2 SG 
resource "aws_security_group" "ec2_sg" {
  name        = "sueshop-ec2-sg"
  description = "EC2 Security group"
  vpc_id      = var.vpc_id

  # HTTP from ALB only
  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  # SSH ONLY from Bastion SG
  ingress {
    description     = "SSH from Bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
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