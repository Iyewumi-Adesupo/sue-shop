# DB subnet group (private subnets only)
resource "aws_db_subnet_group" "sueshop" {
  name       = "sueshop-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "sueshop-db-subnet-group"
  }
}

# Read DB credentials from Secrets Manager
data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = var.db_secret_arn
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
}

# Creating RDS instance
resource "aws_db_instance" "sueshopdb" {
  identifier     = "sueshop-db"
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = var.db_name
  username = local.db_creds.username
  password = local.db_creds.password

  db_subnet_group_name   = aws_db_subnet_group.sueshop.name
  vpc_security_group_ids = [var.db_security_group_id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name = "sueshop-db"
  }
}