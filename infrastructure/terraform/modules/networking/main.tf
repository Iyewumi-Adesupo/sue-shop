# Creating vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "sueshop-vpc"
  }
}

# Creating public subnets
resource "aws_subnet" "public" {
  count = length(var.public_azs)

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.public_azs[count.index]
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "sueshop-public-${count.index + 1}"
  }
}

# creating private subnets
resource "aws_subnet" "private" {
  count = length(var.private_azs)

  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.private_azs[count.index]
  cidr_block        = var.private_subnet_cidrs[count.index]

  tags = {
    Name = "sueshop-private-${count.index + 1}"
  }
}

# Creating IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "sueshop-igw"
  }
}

# Elastic IP
resource "aws_eip" "eip" {
  domain = "vpc"
}

# Creating NGW
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "sueshop-ngw"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Creating public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "sueshop-public-rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Creating private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "sueshop-private-rt"
  }
}

resource "aws_route_table_association" "private_rt_assoc" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Creating ALB security group
resource "aws_security_group" "alb_sg" {
  name        = "sueshop-alb-sg"
  description = "Security group for SueShop ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

# Creating ALB
resource "aws_lb" "sueshop_alb" {
  name               = "sueshop-alb"
  load_balancer_type = "application"
  internal           = false

  subnets         = aws_subnet.public[*].id
  security_groups = [aws_security_group.alb_sg.id]
}

# Creating Target group
resource "aws_lb_target_group" "sueshop_tg" {
  name     = "sueshop-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/health"
    interval            = 30
    unhealthy_threshold = 2
  }
}


# HTTP → HTTPS Redirect
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.sueshop_alb.arn
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

# ACM Certificate (ALB)
resource "aws_acm_certificate" "sueshop_acm" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "sueshop_route53" {
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

resource "aws_acm_certificate_validation" "sueshop_acm_validation" {
  certificate_arn         = aws_acm_certificate.sueshop_acm.arn
  validation_record_fqdns = [for r in aws_route53_record.sueshop_route53 : r.fqdn]
}

# Route53 ALB Alias
resource "aws_route53_record" "alb_alias" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.sueshop_alb.dns_name
    zone_id                = aws_lb.sueshop_alb.zone_id
    evaluate_target_health = true
  }
}