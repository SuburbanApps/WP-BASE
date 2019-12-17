resource "aws_security_group" "dv10-sg-wp-base-efs" { 
  name        = "sg-wp-base-efs" // hacer con variables
  description = "SG for WP BASE EFS"
  vpc_id      = "${varvpc_id}"
   tags      = {
        Name = "wp-base"
        Environment = "Development"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
    }

  }

  ingress {
    description     = "Acceso a instancias"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${aws_security_group.dv10-sg-wp-base-instances.id}"]

  }

 
resource "aws_efs_file_system" "dv10-efs-wp-base" {
  creation_token = "Efs Wordpress Test"
  

    tags      = {
        Name = "wp-base"
        Environment = "Development"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
    }
}
