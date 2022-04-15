#------------------------------------
# file: ./IaC/backend/main.tf
#
# Maintainer: Dmitrii Demitov
# email: dmitrii_demitov@epam.com
#------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.1.0"
    }
  }
  required_version = "~>1.0"
}

provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Owner = "dmitrii_demitov@epam.com"
    }
  }
}

# Create S3 bucket
resource "aws_s3_bucket" "demitov-v13-s3" {
  bucket = "demitov-v13"
}

resource "aws_s3_bucket_acl" "demitov-v13-s3-acl" {
  bucket = aws_s3_bucket.demitov-v13-s3.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "demitov-v13-s3-ver" {
  bucket = aws_s3_bucket.demitov-v13-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
