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
variable "sueshop_vpc" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

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

variable "sueshop_igw" {
  type = string
}

variable "sueshop_ngw" {
  type = string
}

variable "sueshop_public_rt" {
  type = string
}

variable "sueshop_private_rt" {
  type = string
}

# ----------------------------
# Compute
# ----------------------------
variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

# ----------------------------
# Database
# ----------------------------
variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "max_allocated_storage" {
  type = number
}

variable "multi_az" {
  type = bool
}

variable "backup_retention_days" {
  type = number
}

variable "skip_final_snapshot" {
  type = bool
}

variable "deletion_protection" {
  type = bool
}