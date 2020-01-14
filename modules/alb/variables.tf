variable "vpc_id" {
    description = "VPC ID where the ALB resources will be created."
    type = "string"
}

variable "public_subnets" {
    description = "VPC Public Subnets where the ALB resources will be created."
    type = list(string)
}

variable "environment_prefix" {
    description = "enviroments"
    type = "map"
    default {
      dev     = "popotitos"
      staging = "st10"
      live    = "lv10"
    }

    }
