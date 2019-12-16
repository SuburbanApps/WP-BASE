#variables globales, comunes a todos los módulos.

variable "vpc_id" {

    type = "string"
    default = "vpc-dc76d7bb"
}

variable "subredes" {
  type    = "list"
  default = ["subnet-650ae83e", "subnet-ea19bc8d" , "subnet-c9cd6f80"]
}