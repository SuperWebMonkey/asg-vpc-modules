# vpc 
output "vpc_id" {
    value = "$aws_vpc.vpc.id"
}

# public subnets
output "subnet_1_id" {
    value = aws_subnet.public-subnet[0].id
}

output "subnet_2_id" {
    value = aws_subnet.public-subnet[1].id
}

output "subnet_3_id" {
    value = aws_subnet.public-subnet[2].id
}

# private subnets
output "subnet_4_id" {
    value = aws_subnet.private-subnet[0].id
}

output "subnet_5_id" {
    value = aws_subnet.private-subnet[1].id
}

output "subnet_6_id" {
    value = aws_subnet.private-subnet[2].id
}

output "timestamp" {
    value = local.timestamp
}