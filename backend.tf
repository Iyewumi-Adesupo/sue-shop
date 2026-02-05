terraform {
  backend "s3" {
    bucket         = "sue-shop-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "sue-shop-terraform-locks"
  }
}