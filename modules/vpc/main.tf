/* 
    Create a vpc with 3 public subnets and 3 private subnets
    Create 2 route tables
    Create a nat gateway
*/

# local value for timestamp
locals {
  timestamp = formatdate("DD MMM YYYY hh:mm ZZZ",timestamp())
}

# vpc
resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "chrise-tf-vpc"
        timestamp = local.timestamp
    }
}

# using count to make public subnets, use a for loop
# public subnets
resource "aws_subnet" "public-subnet" {
    count = 3
    vpc_id = aws_vpc.vpc.id
    cidr_block = cidrsubnet(var.cidr_block, 4, count.index)
    map_public_ip_on_launch = true
    # availability_zone = "us-west-1a"

    tags = {
        Name = "chris-public-tf-subnet-${count.index + 1}"
        timestamp = local.timestamp
    }
}

# private subnets
resource "aws_subnet" "private-subnet" {
    count = 3
    vpc_id = aws_vpc.vpc.id
    cidr_block = cidrsubnet(var.cidr_block, 4, count.index + 3)
    map_public_ip_on_launch = false
    
    tags = {
        Name = "chris-tf-private-subnet-${count.index + 1}"
        timestamp = local.timestamp
    }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name  = "chris-tf-igw"
    Enviornment = "chris-environment"
    timestamp = local.timestamp
  }
}

# Elastic IP 
resource "aws_eip" "nat_eip" {
  vpc = true
}

# Nat Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public-subnet[0].id
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "chris-tf-nat-gw"
    timestamp = local.timestamp
  }
}

# Public Route table
resource "aws_route_table" "pub-rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "${var.cidr_all}" # all IPs
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "chris-tf-public-table"
        timestamp = local.timestamp
    }
}

# Private Route Table
resource "aws_route_table" "priv-rt" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "${var.cidr_all}"
        nat_gateway_id = aws_nat_gateway.nat.id
    }

    tags = {
        Name = "chris-tf-private-table"
        timestamp = local.timestamp
    }
}

# Public route table association
resource "aws_route_table_association" "pub-assoc" {
  count = 3
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.pub-rt.id
}

# Private route table association 
resource "aws_route_table_association" "priv-assoc" {
  count = 3
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.priv-rt.id
}

# Security Group 
resource "aws_security_group" "sg_22" {
  name = "chris-tf-sg-1"
  vpc_id = "${aws_vpc.vpc.id}"

  # SSH access from the VPC
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["${var.cidr_all}"]
  }

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["${var.cidr_all}"]
  }

  ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["${var.cidr_all}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr_all}"]
  }
}