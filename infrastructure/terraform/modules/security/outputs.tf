output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}
