#Adjuntar variables de entorno
 locals {
  environment_prefix          = "${lookup(local.env.environment_prefix, terraform.workspace, local.environment_prefix)}"
  environment_name            = "${lookup(local.env.environment_name, terraform.workspace, local.environment_name)}"
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
resource "aws_db_instance" "db-wp-base" { 
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "MariaDB"
  name                    = "dbwp"
  identifier              = "db-wp" 
  #db_subnet_group_name    = "${aws_db_subnet_group." hacer variable
  username                = "root"
  password                = "12345678"
  vpc_security_group_ids  = ["${aws_security_group.sg-wp-base-rds.id}"]
  skip_final_snapshot     = true
  multi_az                = "${var.az_select}"
  max_allocated_storage = 100
  db_subnet_group_name = "${aws_db_subnet_group.sbg-wp-base.id}"

  tags = {
    Name = "${local.environment_prefix}-db-wp-base"
    Environment = "${local.environment_name}"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
}

resource "aws_db_subnet_group" "sbg-wp-base" {
  name       = "${local.environment_prefix}-sbg-wp-base"
  subnet_ids = "${var.private_subnets}"

  tags = {
    Name = "${local.environment_prefix}-sbg-wp-base"
    Environment = "${local.environment_name}"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }

}

resource "aws_security_group" "sg-wp-base-rds" {
  name        = "${local.environment_prefix}-sg-wp-base-rds"
  description = "SG for RDS"
  vpc_id      = "${var.vpc_id}"

  
  ingress {
    description     = "HTTP from internet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.environment_prefix}-sg-wp-base-rds"
    Environment = "${local.environment_name}"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
}

