#------------------------------------
# file: ./IaC/AWS/provider.tf
#
# Maintainer: Dmitrii Demitov
# email: demitov@gmail.com
#------------------------------------

provider "aws" {
  region = var.region

  # Note: keys reading from ENV
  # access_key    = var.AWS_ACCESS_KEY_ID
  # secret_key    = var.AWS_SECRET_ACCESS_KEY
  # session_token = var.AWS_SESSION_TOKEN

  default_tags {
    tags = {
      Owner   = "demitov@gmail.com"
      Project = "Diploma V13"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.11.0"
    }
  }
  backend "s3" {
    bucket  = "demitov-v13"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "eu-west-3"
  }
  required_version = "~>1.0"
}
