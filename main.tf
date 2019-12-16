
#archivo principal de configuración.

#Declaramos provider

provider "aws" {
    region ="eu-west-1"
}

module "ec2" {
  source = "./modules/ec2"
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