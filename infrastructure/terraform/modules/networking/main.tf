# Creating a VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_id
  }
}

#create 2 public subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.AZ1
  cidr_block        = var.public_subnet_1_cidr

  tags = {
    Name = var.sueshop_public_subnet_1
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.AZ2
  cidr_block        = var.public_subnet_2_cidr

  tags = {
    Name = var.sueshop_public_subnet_2
  }
}

#create 2 private subnet 
resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.AZ1
  cidr_block        = var.private_subnet_1_cidr

  tags = {
    Name = var.sueshop_private_subnet_1
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.AZ2
  cidr_block        = var.private_subnet_2_cidr

  tags = {
    Name = var.sueshop_private_subnet_2
  }
}

#Creating Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.sueshop_igw
  }
}

#Creating elastic ip
resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

#Creating nat gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet-1.id
  tags = {
    Name = var.sueshop_ngw
  }
}

# creating a public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.sueshop_public_rt
  }
}

# attaching public subnet 1 to public route table
resource "aws_route_table_association" "public_rt_SN1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public_rt.id
}

# attaching public subnet 2 to public route table
resource "aws_route_table_association" "public_rt_SN2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public_rt.id
}

# creating a private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = var.sueshop_private_rt
  }
}

# attaching private subnet 1 to private route table
resource "aws_route_table_association" "private_rt_SN1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private_rt.id
}

# attaching private subnet 2 to private route table
resource "aws_route_table_association" "private_rt_SN2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private_rt.id
}

# creating alb 
resource "aws_lb" "sueshop-alb" {
  name               = "sueshop-alb"
  load_balancer_type = "application"
  internal           = false

  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.alb_sg.id]
}

# creating target group 
resource "aws_lb_target_group" "sueshop-tg" {
  name     = "sueshop-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    interval            = 30
    unhealthy_threshold = 2
  }
}

# creating a redirect HTTP -> HTTPS 
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.sueshop-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# creating ACM 
resource "aws_acm_certificate" "sueshop_acm" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# creating ACM Validation 
resource "aws_route53_record" "acm_validation" {
  depends_on = [aws_acm_certificate.sueshop_acm]

  for_each = {
    for dvo in aws_acm_certificate.sueshop_acm.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

# creating ACM certificate validation 
resource "aws_acm_certificate_validation" "sueshop_acm_cert" {
  certificate_arn = aws_acm_certificate.sueshop_acm.arn

  validation_record_fqdns = [
    for record in aws_route53_record.acm_validation :
    record.fqdn
  ]
}

# creating Route53
resource "aws_route53_record" "sueshop_route53" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.sueshop-alb.dns_name
    zone_id                = aws_lb.sueshop-alb.zone_id
    evaluate_target_health = true
  }
}

# Security Groups for load balancer
resource "aws_security_group" "alb_sg" {
  name        = "sueshop-alb-sg"
  description = "Security group for SueShop ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sueshop-alb-sg"
  }
}
