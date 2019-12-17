resource "aws_efs_file_system" "dv10-efs-wp-base" {
  creation_token = "Efs Wordpress Test"

   tag_specifications {
    resource_type = "EFS"
    tags          = {
        Name = "wp-base"
        Environment = "Development"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
    }
   }
}