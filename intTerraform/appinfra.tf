provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = "us-east-1"
}

resource "aws_vpc" "Dep9_vpc" {
  cidr_block = "172.28.0.0/16"

  tags = {
    "Name" = "Dep9_vpc_"
  }
}

resource "aws_subnet" "publicA" {
  vpc_id            = aws_vpc.Dep9_vpc.id
  cidr_block        = "172.28.0.0/18"
  availability_zone = "us-east-1a"
  
  tags = {
    "Name" = ""
  }
}

resource "aws_subnet" "privateA" {
  vpc_id            = aws_vpc.Dep9_vpc.id
  cidr_block        = "172.28.64.0/18"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "private-us-east-1a"
  }
}

resource "aws_subnet" "publicB" {
  vpc_id            = aws_vpc.Dep9_vpc.id
  cidr_block        = "172.28.128.0/18"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "public-us-east-1b"
  }
}

resource "aws_subnet" "privateB" {
  vpc_id            = aws_vpc.Dep9_vpc.id
  cidr_block        = "172.28.192.0/18"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "private-us-east-1b"
  }
}


output "subnet_publicA" {
  value = aws_subnet.publicA.id
}

output "subnet_privateA" {
  value = aws_subnet.privateA.id
}

output "subnet_publicB" {
  value = aws_subnet.publicB.id
}

output "subnet_privateB" {
  value =aws_subnet.privateB.id
}


resource "aws_route_table_association" "publicA_rt" {
  subnet_id      = aws_subnet.publicA.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "privateA_rt" {
  subnet_id      = aws_subnet.privateA.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "publicB_rt" {
  subnet_id      = aws_subnet.publicB.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "privateB_rt" {
  subnet_id      = aws_subnet.privateB.id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "elastic-ip" {
  domain = "vpc"
}

resource "aws_internet_gateway" "Dep9_igw" {
  vpc_id = aws_vpc.Dep9_vpc.id
}

resource "aws_nat_gateway" "Dep9_ngw" {
  subnet_id     = aws_subnet.publicA.id
  allocation_id = aws_eip.elastic-ip.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Dep9_vpc.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.Dep9_vpc.id
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Dep9_igw.id
}

resource "aws_route" "private_ngw" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.Dep9_ngw.id
}

