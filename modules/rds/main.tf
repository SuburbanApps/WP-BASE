resource "aws_db_instance" "dv10-db-wp-base" { 
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "MariaDB"
  name                    = "WP Base de Datos" #hacer variable
  identifier              = "db-wp-test" ##hacer variable
  #db_subnet_group_name    = "${aws_db_subnet_group.MyportalRDSSubnetGroup.id}"
  username                = "${data.aws_ssm_parameter.user_db.value}"
  password                = "${data.aws_ssm_parameter.pwd_db.value}"
  #vpc_security_group_ids  = ["${aws_security_group.MyportalRDSSecurityGroup.id}"]
  skip_final_snapshot     = true
  multi_az                = "${var.az_select}"
  max_allocated_storage = 100
}