variable "vpc_id" {
    description = "VPC ID where the compute resources will be created."
    type = "string"
}

variable "security_group_ids" {
    description = "List of security group IDs that will apply to this compute resources"
    type = list(string)
}