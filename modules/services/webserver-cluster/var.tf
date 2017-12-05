variable "aws_region" {
    description = "EC2 Region"
    default = "ap-southeast-1"
}

variable "ami" {
  description = "The AMI to run in the cluster"
  default     = "ami-ee0eb98d" # Ubuntu 16.04 LTS
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

variable "public_subnet_id" {
    description = "Subnet ID for ASG"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
}

variable "vpc_id" {
  description = "The VPC used to launch resources in"
}