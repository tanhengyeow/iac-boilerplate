output "db_name" {
  value = "${aws_dynamodb_table.terraform_statelock.name}"
}