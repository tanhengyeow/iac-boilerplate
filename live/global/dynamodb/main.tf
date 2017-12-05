provider "aws" {
  region = "${var.aws_region}"
}

# Dynamodb for state locking
resource "aws_dynamodb_table" "terraform_statelock" {
  name           = "${var.dynamodb_name}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}