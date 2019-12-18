#

variable "az_select" {

    default = false # true in live.

}

variable "private_subnets" {
    description = "VPC Private Subnets where the compute resources will be created."
    type = list(string)
}