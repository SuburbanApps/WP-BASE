

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
  #user_db = "${local.user_db}"
  #pwd_db = "${local.pwd_db}"
  private_subnets = "${local.private_subnet_ids}"
  #az_select  = "${local.az_select}" 
  vpc_id = "${local.vpc_id}"
  #incoming_sg_ids = ["${module.alb.alb_sg_id}"]
  

}

terraform { 
  backend "s3" {
    bucket = "vim-terraform-backend-copy"
    dynamodb_table = "vim-terraform-backend"
    key = "wp-base.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}