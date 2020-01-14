variable "vpc_id" {
    description = "VPC ID where the ALB resources will be created."
    type = "string"
}

variable "public_subnets" {
    description = "VPC Public Subnets where the ALB resources will be created."
    type = list(string)
}
 locals {

  environment_prefix          = "${lookup(local.env.environment_prefix, terraform.workspace)}"
  environment_name            = "${lookup(local.env.environment_name, terraform.workspace)}"
 
}