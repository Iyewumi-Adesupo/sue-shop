module "networking" {
  source  = "./modules/networking"
  vpc_cidr = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "security" {
  source = "./modules/security"
}

module "compute" {
  source     = "./modules/compute"
  instance_type = "t3.micro"
  key_name      = "your-key-pair"
  subnet_id     = module.networking.public_subnet_ids[0]
  vpc_security_group_ids = [module.security.web_sg_id]
}

module "storage" {
  source = "./modules/storage"
  bucket_name = "sue-shop-media"
}