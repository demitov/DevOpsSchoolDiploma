#------------------------------------
# file: ./IaC/AWS/vpc.tf
#
# Maintainer: Dmitrii Demitov
# email: demitov@gmail.com
#------------------------------------

# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(var.tags, { Name = "VPC" })
}

# Availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

#
# Create subnets
#
resource "aws_subnet" "subnet-public-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags              = merge(var.tags, { Name = "Public subnet in ${data.aws_availability_zones.available.names[0]}" })
}

resource "aws_subnet" "subnet-public-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags              = merge(var.tags, { Name = "Public subnet in ${data.aws_availability_zones.available.names[1]}" })
}

resource "aws_subnet" "subnet-private-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags              = merge(var.tags, { Name = "Private subnet in ${data.aws_availability_zones.available.names[0]}" })
}

resource "aws_subnet" "subnet-private-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags              = merge(var.tags, { Name = "Private subnet in ${data.aws_availability_zones.available.names[1]}" })
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.vpc.id
  tags       = merge(var.tags, { Name = "Internet Gateway" })
  depends_on = [aws_vpc.vpc]
}

# Nat for Private Networks
resource "aws_eip" "nat-1" {
}

resource "aws_eip" "nat-2" {
}

resource "aws_nat_gateway" "gw-1" {
  allocation_id = aws_eip.nat-1.id
  subnet_id     = aws_subnet.subnet-public-1.id
  tags          = merge(var.tags, { Name = "NAT-1" })
}

resource "aws_nat_gateway" "gw-2" {
  allocation_id = aws_eip.nat-2.id
  subnet_id     = aws_subnet.subnet-public-2.id
  tags          = merge(var.tags, { Name = "NAT-2" })
}

# Route to Internet Gateway
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "Public route table" })
}

# Routes to NAT
resource "aws_route_table" "private-rt-1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw-1.id
  }
  tags = merge(var.tags, { Name = "Private route table 1" })
}

resource "aws_route_table" "private-rt-2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw-2.id
  }
  tags = merge(var.tags, { Name = "Private route table 2" })
}

# Route associations
resource "aws_route_table_association" "public-association-1" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.subnet-public-1.id
}

resource "aws_route_table_association" "public-association-2" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.subnet-public-2.id
}

resource "aws_route_table_association" "private-association-1" {
  route_table_id = aws_route_table.private-rt-1.id
  subnet_id      = aws_subnet.subnet-private-1.id
}

resource "aws_route_table_association" "private-association-2" {
  route_table_id = aws_route_table.private-rt-2.id
  subnet_id      = aws_subnet.subnet-private-2.id
}

# EKS module
