# Creating DB subnet group
resource "aws_db_subnet_group" "sueshop" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.name}-db-subnet-group"
    Environment = var.environment
  }
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = var.db_secret_arn
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.db_credentials.secret_string
  )
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "sueshopdb" {
  identifier = "${var.name}-db"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = true

  db_name  = local.db_creds.database
  username = local.db_creds.db_username
  password = local.db_creds.db_password

  db_subnet_group_name   = aws_db_subnet_group.sueshop.name
  vpc_security_group_ids = [var.db_security_group_id]

  publicly_accessible = false
  multi_az            = var.multi_az

  backup_retention_period = var.backup_retention_days
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  performance_insights_enabled = true

  tags = {
    Name        = "${var.name}-db"
    Environment = var.environment
  }
}