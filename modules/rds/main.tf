resource "aws_db_instance" "dv10-db-wp-base" { 
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "MariaDB"
  name                    = "WPdb" #hacer variable
  identifier              = "db-wp-test" ##hacer variable
  #db_subnet_group_name    = "${aws_db_subnet_group." hacer variable
  username                = "root" #"${var.user_db}"
  password                = "12345678" #"${var.pwd_db}"
  #vpc_security_group_ids  = ["${aws_security_group.id}"]
  skip_final_snapshot     = true
  multi_az                = "${var.az_select}"
  max_allocated_storage = 100
}

resource "aws_db_subnet_group" "dv10-sbg-wp-base" {
  name       = "subnet-groups-wp"
  subnet_ids = "${var.private_subnets}"

}

resource "aws_security_group" "dv10-sg-wp-base-rds" {
  name        = "sg-rds-w`-base"
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
    Name = "dv10-sg-wp-base-alb"
    Environment = "Development"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
}

