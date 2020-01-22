
variable "vpc_id" {
    description = "VPC ID where the compute resources will be created."
    type = string
}
variable "incoming_sg_ids" {
    description = "List of security group IDs that will send traffic to this compute resources."
    type = list(string)
}
variable "private_subnets" {
    description = "VPC Private Subnets where the compute resources will be created."
    type = list(string)
}
