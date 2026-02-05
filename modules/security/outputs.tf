output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}


output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}

output "bastion_sg_id" {
  value       = aws_security_group.bastion_sg.id
  description = "Security group ID for bastion host"
}