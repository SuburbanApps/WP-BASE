
#archivo principal de configuración.

#Declaramos provider

provider "aws" {
    region ="eu-west-1"
}

module "alb" {
  source = "./modules/alb"
  vpc_id = "${local.vpc_id}"
  public_subnets = "${local.public_subnet_ids}"
}

module "ec2" {
  source = "./modules/ec2"
  private_subnets = "${local.private_subnet_ids}"
  vpc_id = "${local.vpc_id}"
  incoming_sg_ids = ["${module.alb.alb_sg_id}"]
  key_pair = "${local.key_pair}"
  target_group_arns = ["${module.alb.tg_arn}"]
  }

module "efs" {
  source ="./modules/efs"
  vpc_id = "${local.vpc_id}"
  incoming_sg_ids = ["${module.alb.alb_sg_id}"]
  private_subnets = "${local.private_subnet_ids}"
}

module "rds" {
  source ="./modules/rds"
  username = "${resource.aws_ssm_parameter.user_db.value}"
  password = "${resource.aws_ssm_parameter.pwd_db.value}"
  #az_select  = "${local.az_select}" 
  #vpc_id = "${local.vpc_id}"
  #incoming_sg_ids = ["${module.alb.alb_sg_id}"]
  private_subnets= "${local.private_subnet_ids}"

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