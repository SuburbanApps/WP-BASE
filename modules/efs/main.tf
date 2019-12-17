resource "aws_security_group" "dv10-sg-wp-base-efs" { 
  name        = "sg-wp-base-efs" // hacer con variables
  description = "SG for WP BASE EFS"
  vpc_id      = "${local.vpc_id}"
   
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
