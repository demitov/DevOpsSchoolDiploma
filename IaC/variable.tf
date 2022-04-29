#------------------------------------
# file: ./IaC/variable.tf
#
# Maintainer: Dmitrii Demitov
# email: demitov@gmail.com
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
  description = "Region Europe (Paris) eu-west-3"
  type        = string
  default     = "eu-west-3"
}

variable "tags" {
  description = "Default tags"
  type        = map(any)
  default = {
    Owner   = "dmitrii_demitov@epam.com"
    Project = "Diploma V13"
  }
}

variable "k8s-version" {
  description = "EKS Kubernetes version"
  default     = "1.21"
}

# variable "demitov-v13-s3-bucket" {
#   description = "Private S3 bucket"
#   type = string
#   default = "demitov-v13"
# }
