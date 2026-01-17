module "compute" {
  source = "./modules/compute"

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  security_group_ids = [module.security.ec2_sg_id]
  environment        = var.environment
  private_subnet_ids  = module.networking.private_subnet_ids
  iam_instance_profile_name = module.security.ec2_instance_profile_name
  target_group_arns = [module.networking.target_group_arn]
}

module "networking" {
  source = "./modules/networking"

  # DNS
  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id

  # VPC
  sueshop_vpc = var.sueshop_vpc
  vpc_cidr    = var.vpc_cidr

  # Availability Zones
  AZ1 = var.AZ1
  AZ2 = var.AZ2

  # Public subnets
  sueshop_public_subnet_1 = var.sueshop_public_subnet_1
  sueshop_public_subnet_2 = var.sueshop_public_subnet_2
  public_subnet_1_cidr    = var.public_subnet_1_cidr
  public_subnet_2_cidr    = var.public_subnet_2_cidr

  # Private subnets
  sueshop_private_subnet_1 = var.sueshop_private_subnet_1
  sueshop_private_subnet_2 = var.sueshop_private_subnet_2
  private_subnet_1_cidr    = var.private_subnet_1_cidr
  private_subnet_2_cidr    = var.private_subnet_2_cidr

  # Routing
  sueshop_igw        = var.sueshop_igw
  sueshop_ngw        = var.sueshop_ngw
  sueshop_public_rt  = var.sueshop_public_rt
  sueshop_private_rt = var.sueshop_private_rt

  # ALB
  alb_security_group_ids = [module.security.alb_security_group_id]
}

module "security" {
  source = "./modules/security"

  vpc_id        = module.networking.vpc_id
  s3_bucket_arn = module.storage.bucket_arn

  # Database identifiers (NOT secrets)
  db_name     = var.db_name
  db_username = var.db_username
}

module "database" {
  source = "./modules/database"

  private_subnet_ids   = module.networking.private_subnet_ids
  db_security_group_id = module.security.rds_security_group_id

  db_name     = var.db_name
  db_username = var.db_username
  db_secret_arn = module.security.db_secret_arn
}

module "storage" {
  source      = "./modules/storage"
  bucket_name = "sueshop-assets-prod"
  environment = var.environment
}
