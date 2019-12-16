
#archivo principal de configuración.

#Declaramos provider

provider "aws" {
    region ="eu-west-1"
}

module "alb" {
  source = "./modules/alb"

  vpc_id = "${local.vpc_id}"
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id = "${local.vpc_id}"
  incoming_sg_ids = "${module.alb.alb_sg_id}"
}

terraform {
  backend "s3" {
    bucket = "vim-terraform-backend"
    dynamodb_table = "vim-terraform-backend"
    key = "wp-base.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}