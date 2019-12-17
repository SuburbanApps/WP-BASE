resource "aws_efs_file_system" "dv10-efs-wp-base" {
  creation_token = "Efs Wordpress Test"

  tags = {
    Name = "EFS-test"
  }
}
