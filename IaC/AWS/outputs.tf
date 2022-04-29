#------------------------------------
# file: ./IaC/AWS/outputs.tf
#
# Maintainer: Dmitrii Demitov
# email: demitov@gmail.com
#------------------------------------

output "aws_availability_zones" {
  value = data.aws_availability_zones.available.names
}

output "amazon-linux" {
  value = data.aws_ami.amazon-linux.id
}
