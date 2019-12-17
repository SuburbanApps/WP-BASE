variable "vpc_id" {
    description = "VPC ID where the compute resources will be created."
    type = "string"
}

variable "incoming_sg_ids" {
    description = "List of security group IDs that will send traffic to this compute resources."
    type = list(string)
}

variable "public_subnets" {
    description = "VPC Public Subnets where the ALB resources will be created."
    type = list(string)
}