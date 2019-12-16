resource "aws_security_group" "dv10-wp-instances-sg" {
  name        = "dv10-wp-instances-sg"
  description = "Security Group Instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description     = "Traffic from Alb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.wp-alb-sg.id}"]

  }
    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "dv10-wp-base-launch-template" { // CONFIGURACION DE LANZAMIENTO DE PLANTILLA.
  name_prefix   = "dv10-wp-base-launch-template"
  image_id      =   "ami-031de832435c04744"
  instance_type           = "t2.micro"
  key_name                = "dev-tf-wp-launch-template"

  tag_specifications {
    resource_type = "instance"
    tags          = {
        Name = "wp-base"
        Environment = "Development"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags          = {
        Name = "wp-base"
        Environment = "Development"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
    }
  }

  tags = {
        Name = "wp-base"
        Environment = "Development"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
  }
}