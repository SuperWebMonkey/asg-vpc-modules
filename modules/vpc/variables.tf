variable "cidr_block" {
    type = string
    description = "IP range used for vpc"
    default = "10.0.0.0/16"
}

variable "cidr_all" {
    type = string
    default = "0.0.0.0/10"
}

output "sg_1_id" {
    value = "${aws_security_group.sg_22.id}"
}

