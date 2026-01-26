output "db_endpoint" {
  value = aws_db_instance.sueshopdb.endpoint
}

output "db_port" {
  description = "Database port"
  value       = aws_db_instance.sueshopdb.port
}

output "db_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.sueshopdb.id
}

output "db_subnet_group" {
  description = "DB subnet group name"
  value       = aws_db_subnet_group.sueshop.name
}