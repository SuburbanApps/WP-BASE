
#archivo principal de configuración.

#Declaramos provider

provider "aws" {
    region ="eu-west-1"
}
  
terraform {
  backend "s3" {
    bucket = "arn:aws:s3:::vim-terraform-backend"
    dynamodb_table = "arn:aws:dynamodb:eu-west-1:190761377083:table/vim-terraform-backend"
    key = "myportal"
    role_arn = "arn:aws:iam::143491526082:role/TerraformAccess"
    profile = "terraform"
    region = "eu-west-1"
    encrypt = true
    kms_key_id = "arn:aws:kms:eu-west-1:143491526082:key/7f72131a-43a1-49d8-aab0-9eab6ee66178"
  }
}