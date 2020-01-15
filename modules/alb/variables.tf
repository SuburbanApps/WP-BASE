variable "vpc_id" {
    description = "VPC ID where the ALB resources will be created."
    type = "string"
}

variable "public_subnets" {
    description = "VPC Public Subnets where the ALB resources will be created."
    type = list(string)
}
locals {
  env = {
    environment_prefix = {
      dev     = "dv10"
      staging = "st10"
      live    = "lv10"
    }
    environment_name = {
      dev     = "Development"
      staging = "Staging"
      live    = "Live"
    }
  }
}


