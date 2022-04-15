#------------------------------------
# file: ./IaC/lambda.tf
#
# Maintainer: Dmitrii Demitov
# email: dmitrii_demitov@epam.com
#------------------------------------

resource "aws_lambda_function" "demitov-v13-lambda" {
  function_name = "demitov-v13-lambda"
  role = var.epam-roles-LambdaDynamoDBRole-arn
  # layers = [demitov-v13-lambda-layer-1]
  runtime = "python3.9"
  handler = "backend.lambda_handler"
  package_type = "Zip"
  s3_bucket = var.demitov-v13-s3-bucket
  s3_key = "backend.zip"
  timeout = 59
}
