
variable "az_select" {
    default = false
    }

variable "private_subnets" {
    description = "VPC Private Subnets where the compute resources will be created."
    type = list(string)
}

locals {

private_subnet_ids = ["subnet-650ae83e", "subnet-ea19bc8d" , "subnet-c9cd6f80"]

}

#variable user_db" {
    #description = "User will be db instance created."
    #type = string
    #default = "root"
#}

#variable pwd_db" {
    #description = "Password will be db instance created."
    #type = string
    #default = "12345678"
#}


