#Adjuntar variables de entorno
 locals {
  environment_prefix          = "${lookup(local.env.environment_prefix, terraform.workspace)}"
  environment_name            = "${lookup(local.env.environment_name, terraform.workspace)}"
    env = {
      environment_prefix = {
        dev     = "dv10"
        staging = "st10"
        live    = "lv10"
          }
    
      environment_name = {
        dev     = "Development"
        staging = "Staging"
        live    = "Live"
        }

  }
  #not_in_production = "${local.not_in_production_mapping[terraform.workspace]}" 
  #not_in_production_mapping = {
   
    #dev         = true
    #staging     = true
    #live        = false
    #}
  
 }
resource "aws_security_group" "sg-wp-base-efs" { 
  name        = "${local.environment_prefix}-sg-wp-base-efs"
  description = "Security Group for EFS"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description     = "HTTP from internet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    #security_groups = "${var.incoming_sg_ids}" ERROR!!!
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.environment_prefix}-wp-base-efs"
    Environment = "${local.environment_name}"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
}
   

resource "aws_efs_file_system" "efs-wp-base" {
  creation_token = "Efs Wordpress Test"
  

    tags      = {
        Name = "${local.environment_prefix}-efs-wp-base-efs"
        Environment = "${local.environment_name}"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
    }
}

resource "aws_efs_mount_target" "mt-wp-base-efs" {
    count = 3
    file_system_id  = "${aws_efs_file_system.efs-wp-base.id}"
    subnet_id       =  "${var.private_subnets}"
    ##security_groups = "${var.incoming_sg_ids}"
}

