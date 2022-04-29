#------------------------------------
# file: ./IaC/AWS/vpc.tf
#
# Maintainer: Dmitrii Demitov
# email: demitov@gmail.com
#------------------------------------

# Create VPC
resource "aws_vpc" "v13-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(var.tags, { Name = "VPC" })
}

# Availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create subnets
