#variables del Balanceador.

variable "subredes" {
  type    = "list"
  default = ["subnet-650ae83e", "subnet-ea19bc8d" , "subnet-c9cd6f80"]
}

variable "vpcidentificador" {
  type    = "string"
  default = "vpc-dc76d7bb"
}