#------------------------------------
# file: ./IaC/variable.tf
#
# Maintainer: Dmitrii Demitov
# email: dmitrii_demitov@epam.com
#------------------------------------

# variable "AWS_ACCESS_KEY_ID" {
#   type = string
# }

# variable "AWS_SECRET_ACCESS_KEY" {
#   type = string
# }

# variable "AWS_SESSION_TOKEN" {
#   type = string
# }

variable "region" {
description = "Region Europe (Frankfurt) eu-central-1"
  type    = string
  default = "eu-central-1"
}

variable "epam-vpc-id" {
  description = "EPAM VPC"
  type = string
  default = "vpc-6c6dfe06"
  
}

variable "epam-subnets-ids" {
  description = "EPAM Subnets ids"
  type = list
  default = [
    "subnet-18068254",
    "subnet-dc4a30b6",
    "subnet-2965d455",
    ]
}

variable "epam-sg-id" {
  description = "Security group Belarus, Russia offices"
  type = string
  default = "sg-0a8b5db2a7dcca42a"
}

variable "epam-roles-EC2Role" {
  description = "Allows EC2 instances to call AWS services on your behalf"
  type = string
  default = "EC2Role"
}

variable "epam-roles-eks_role" {
  description = "Allows access to other AWS service resources that are required to operate clusters managed by EKS"
  type = string
  default = "eks_role"
}

variable "epam-roles-LambdaDynamoDBRole-arn" {
  description = "Allows Lambda functions to call AWS services on your behalf"
  type = string
  default = "arn:aws:iam::156001095759:role/LambdaDynamoDBRole"
}

variable "demitov-v13-s3-bucket" {
  description = "Private S3 bucket"
  type = string
  default = "demitov-v13"
}