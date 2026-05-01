variable "ami_id" {}

variable "instance_type" {}

variable "private_subnet_ids" {}

variable "bastion_sg_id" {}

variable "target_group_arns" {}

variable "environment" {}

variable "iam_instance_profile_name" {}

variable "vpc_id" {}

variable "ssh_key_name" {}

variable "admin_ipv6_cidr" {}

variable "ec2_security_group_id" {
  type = string
}