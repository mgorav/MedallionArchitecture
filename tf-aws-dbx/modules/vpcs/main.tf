variable "vpc1_cidr" {}

variable "vpc2_cidr" {}

resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc1_cidr
}

resource "aws_vpc" "vpc2" {
  cidr_block = var.vpc2_cidr
}

resource "aws_subnet" "private_subnet1" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.0.1.${count.index * 16}/28"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_subnet3" {
  count                   = 1
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = "10.1.1.0/28"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet1[*].id
}
