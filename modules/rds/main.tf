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
  name       = "Subnet-Groups-WP"
  subnet_ids = "${var.private_subnets[count.index]}"

  
}