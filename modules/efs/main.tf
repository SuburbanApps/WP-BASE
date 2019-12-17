resource "aws_security_group" "dv10-sg-wp-base-efs" { 
  name        = "dv10-sg-wp-base-efs" //usar prefix
  description = "Security Group for EFS"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description     = "HTTP from internet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = "${var.incoming_sg_ids}"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-wp-base-efs"
    Environment = "Development"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
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

resource "aws_efs_mount_target" "dv10-mt-wp-base-efs" {
  
    file_system_id  = "${aws_efs_file_system.dv10-efs-wp-base.id}"
    subnet_id       = "${var.private_subnets}" 
    security_groups = "${aws_security_group.dv10-sg-wp-base-efs.id}"

    tags      = {
        Name = "wp-base"
        Environment = "Development"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
    }
}

