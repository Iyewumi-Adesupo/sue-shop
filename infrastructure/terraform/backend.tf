terraform {
  backend "s3" {
    bucket         = "sue-shop-terraform-state"
    key            = "env/dev/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    use_lockfile   = true
  }
}