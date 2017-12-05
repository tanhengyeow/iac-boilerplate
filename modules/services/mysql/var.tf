variable "aws_region" {
    default = "ap-southeast-1"
}

variable "db_password" {
  description = "The password for the database"
}

variable "private_subnet_id_1a" {
  description = "private subnet's id used for db subnet group"
}

variable "private_subnet_id_1b" {
  description = "private subnet's id used for db subnet group"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
}

variable "vpc_id" {
  description = "The VPC used to launch resources in"
}