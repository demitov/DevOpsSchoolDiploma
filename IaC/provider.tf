#------------------------------------
# file : ./IaC/provider.tf
#
# Maintainer: Dmitrii Demitov
# email: dmitrii_demitov@epam.com
#------------------------------------

provider "aws" {
  region = var.region

  # Note: keys reading from ENV
  # access_key    = var.AWS_ACCESS_KEY_ID
  # secret_key    = var.AWS_SECRET_ACCESS_KEY
  # session_token = var.AWS_SESSION_TOKEN

  default_tags {
    tags = {
      Owner = "dmitrii_demitov@epam.com"
    }
  }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.1.0"
    }
  }
  backend "s3" {
    bucket  = "demitov-v13"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "eu-central-1"
  }
  required_version = "~>1.0"
}
