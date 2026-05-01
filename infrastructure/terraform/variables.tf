# ----------------------------
# Global
# ----------------------------
variable "environment" {
  type = string
}

variable "region" {
  type = string
}

# ----------------------------
# DNS
# ----------------------------
variable "domain_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

# ----------------------------
# Networking
# ----------------------------
variable "vpc_cidr" { type = string }

variable "public_azs" {
  type = list(string)
}

variable "private_azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

# ----------------------------
# Compute
# ----------------------------
variable "ami_id" { type = string }

variable "instance_type" { type = string }

# ----------------------------
# Database
# ----------------------------
variable "db_name" { type = string }

variable "db_username" { type = string }

variable "instance_class" { type = string }

variable "allocated_storage" { type = number }

variable "max_allocated_storage" { type = number }

variable "multi_az" { type = bool }

variable "backup_retention_days" { type = number }

variable "skip_final_snapshot" { type = bool }

variable "deletion_protection" { type = bool }

variable "admin_ipv6_cidr" {
  type = string
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key name used by bastion and EC2 instances"
}