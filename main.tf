#archivo de configuracion general.

#archivo principal de configuración.

#Declaramos provider

provider "aws" {
    region ="eu-west-1"
}

module "alb" {
    source = "./modules/alb"
    } 
    
module "ec2" { 
    source = "./modules/ec2"
        
} 
module "rds" {
    source = "./modules/rds"
    
} 


module "sg" { 
    source = "./modules/sg"

}

module "efs" { 
    source = "./modules/efs"

}

#module "autoscaling" { llamamos al modulo de los grupos de Autoscaling Proximo paso: importar outputs de los modulos
    #source = "./modules/sg"

#}

terraform {
  backend "s3" {
    #bucket = "telepizza-terraform-backend-tb2apps4uybcub8m"
    #dynamodb_table = "telepizza-terraform-backend-tb2apps4uybcub8m"
    key = "myportal"
    role_arn = "arn:aws:iam::143491526082:role/TerraformAccess"
    profile = "terraform"
    region = "eu-west-1"
    encrypt = true
    kms_key_id = "arn:aws:kms:eu-west-1:143491526082:key/7f72131a-43a1-49d8-aab0-9eab6ee66178"
  }
}