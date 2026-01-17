module "compute" {
  source = "./modules/compute"

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = module.networking.public_subnet_id
  key_name           = var.key_name
  security_group_ids = [module.security.ec2_sg_id]
  user_data          = file("${path.module}/user_data.sh")
  environment        = var.environment
  subnet_id           = module.networking.public_subnet_id
  private_subnet_ids  = module.networking.private_subnet_ids

  security_group_ids = [module.security.ec2_security_group_id]

  target_group_arns = [module.networking.target_group_arn]

  user_data = file("${path.module}/modules/compute/user_data.sh")
}

module "networking" {
  source = "./modules/networking"
  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id
  sueshop_vpc = var.sueshop_vpc
  AZ1 = var.AZ1
  AZ2 = var.AZ2
  sueshop_public_subnet_1  = var.sueshop_public_subnet_1
  sueshop_public_subnet_2  = var.sueshop_public_subnet_2
  sueshop_private_subnet_1 = var.sueshop_private_subnet_1
  sueshop_private_subnet_2 = var.sueshop_private_subnet_2
  sueshop_igw        = var.sueshop_igw
  sueshop_ngw        = var.sueshop_ngw
  sueshop_public_rt  = var.sueshop_public_rt
  sueshop_private_rt = var.sueshop_private_rt
  alb_security_group_ids = [module.security.alb_security_group_id]
}