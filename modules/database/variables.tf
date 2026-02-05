variable "name" {
  description = "Base name for database resources (e.g. sueshop)"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of PRIVATE subnet IDs for RDS"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnets are required for RDS."
  }
}

variable "db_security_group_id" {
  description = "Security group ID allowing Postgres access (5432)"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of Secrets Manager secret containing DB credentials"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum autoscaled storage in GB"
  type        = number
  default     = 100
}

variable "multi_az" {
  description = "Enable Multi-AZ for high availability"
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion (true for dev)"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Prevent accidental DB deletion"
  type        = bool
  default     = false
}