module "compute" {
  source = "./modules/compute"

  vpc_id                    = module.networking.vpc_id
  bastion_sg_id             = module.security.bastion_sg_id
  private_subnet_ids        = module.networking.private_subnet_ids
  iam_instance_profile_name = module.security.ec2_instance_profile_name
  target_group_arns         = [module.networking.target_group_arn]
  ec2_security_group_id     = module.security.ec2_security_group_id

  ami_id          = var.ami_id
  instance_type   = var.instance_type
  environment     = var.environment
  admin_ipv6_cidr = var.admin_ipv6_cidr
  ssh_key_name    = aws_key_pair.bastion.key_name
}

module "networking" {
  source = "./modules/networking"

  vpc_cidr = var.vpc_cidr

  public_azs           = var.public_azs
  private_azs          = var.private_azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id
}

module "security" {
  source = "./modules/security"

  vpc_id                = module.networking.vpc_id
  alb_security_group_id = module.networking.alb_security_group_id
  admin_ipv6_cidr       = var.admin_ipv6_cidr
  db_name               = var.db_name
  db_username           = var.db_username
}

resource "aws_key_pair" "bastion" {
  key_name   = "sueshop-bastion-key"
  public_key = file("~/.ssh/sueshop-bastion.pub")
}

module "bastion" {
  source           = "./modules/bastion"
  ami_id           = var.ami_id
  instance_type    = "t3.micro"
  public_subnet_id = module.networking.public_subnet_ids[0]
  ssh_key_name     = aws_key_pair.bastion.key_name
  bastion_sg_id    = module.security.bastion_sg_id
  environment      = var.environment
}

module "database" {
  source = "./modules/database"

  name                 = "sueshop"
  environment          = var.environment
  private_subnet_ids   = module.networking.private_subnet_ids
  db_security_group_id = module.security.rds_security_group_id
  db_secret_arn        = module.security.db_secret_arn

  multi_az            = var.multi_az
  deletion_protection = var.deletion_protection
}

module "storage" {
  source = "./modules/storage"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  bucket_name = "sueshop-assets-prod"
  environment = var.environment
}
