#

variable "az_select" {
    
    default = false
    }

variable "private_subnets" {
    description = "VPC Private Subnets where the compute resources will be created."
    type = list(string)
}

variable user_db" {
    description = "User will be db instance created."
    type = string
}

variable pwd_db" {
    description = "Password will be db instance created."
    type = string
}


