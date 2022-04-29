#------------------------------------
# file: ./IaC/AWS/main.tf
#
# Maintainer: Dmitrii Demitov
# email: demitov@gmail.com
#------------------------------------

# Get AMI for last Amazon Linux EC2
data "aws_ami" "amazon-linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
  owners = ["amazon"]
}
