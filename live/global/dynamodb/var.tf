variable "aws_region" {
    default = "ap-southeast-1"
}

variable "dynamodb_name" {
  description = "The name of the DynamoDB. Must be globally unique."
  default = "lock-db"
}