#------------------------------------
# file: ./IaC/outputs.tf
#
# Maintainer: Dmitrii Demitov
# email: dmitrii_demitov@epam.com
#------------------------------------

output "epam-vpc-id" {
  value = var.epam-vpc-id
}

output "epam-subnets-ids" {
  value = var.epam-subnets-ids
}

output "epam-sg-id" {
  value = var.epam-sg-id
}

output "epam-roles-EC2Role" {
  value = var.epam-roles-EC2Role
}

output "epam-roles-eks_role" {
  value = var.epam-roles-eks_role
}

output "epam-roles-LambdaDynamoDBRole-arn" {
  value = var.epam-roles-LambdaDynamoDBRole-arn
}

output "amazon-linux" {
  value = data.aws_ami.amazon-linux.name
}
