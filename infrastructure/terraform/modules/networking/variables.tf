variable "domain_name" {}
variable "hosted_zone_id" {}

variable "alb_security_group_ids" {}

variable "sueshop_vpc" {}

variable "vpc_cidr" {}

variable "public_subnet_1_cidr" {}
variable "public_subnet_2_cidr" {}

variable "private_subnet_1_cidr" {}
variable "private_subnet_2_cidr" {}

variable "AZ1" {}
variable "AZ2" {}

variable "sueshop_public_subnet_1" {}
variable "sueshop_public_subnet_2" {}

variable "sueshop_private_subnet_1" {}
variable "sueshop_private_subnet_2" {}

variable "sueshop_igw" {}
variable "sueshop_ngw" {}

variable "sueshop_public_rt" {}
variable "sueshop_private_rt" {}