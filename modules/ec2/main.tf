resource "aws_launch_template" "dev-wp-base-launch-template" { // CONFIGURACION DE LANZAMIENTO DE PLANTILLA.
  name_prefix   = "dev-wp-base-launch-template"
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