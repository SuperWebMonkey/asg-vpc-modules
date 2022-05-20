# vpc 
output "vpc_id" {
    value = "$aws_vpc.vpc.id"
}

# public subnets
output "subnet_1_id" {
    value = "${aws_subnet.subnet-1.id}"
}

output "subnet_2_id" {
    value = "${aws_subnet.subnet-2.id}"
}

output "subnet_3_id" {
    value = "${aws_subnet.subnet-3.id}"
}

# private subnets
output "subnet_4_id" {
    value = "${aws_subnet.subnet-4.id}"
}

output "subnet_5_id" {
    value = "${aws_subnet.subnet-5.id}"
}

output "subnet_6_id" {
    value = "${aws_subnet.subnet-6.id}"
}

output "sg_1_id" {
    value = "${aws_security_group.sg_22.id}"
}