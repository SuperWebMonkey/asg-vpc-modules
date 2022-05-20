variable "AWS_KEY_PAIR" {
    default = "../other-files"
}

variable "cidr_vpc" {
    type = string
    description = "IP range used for vpc"
    default = "10.0.0.0/16"
}


