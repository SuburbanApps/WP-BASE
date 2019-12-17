resource "aws_efs_file_system" "dv10-efs-base-wp" {
  creation_token = "Efs Wordpress Test"

  tags = {
    Name = "EFS-test"
  }
}