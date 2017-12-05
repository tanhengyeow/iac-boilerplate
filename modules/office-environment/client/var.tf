variable "aws_region" {
    description = "EC2 Region"
    default = "ap-southeast-1"
}

variable "ami" {
  description = "The AMI to provision"
  default     = "ami-ee0eb98d" # Ubuntu 16.04 LTS
  # "ami-528db200" - Windows 7
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
}

variable "instance_number" {
  description = "The number of EC2 Instances to run"
}

variable "client_name" {
  description = "The unique name of the client machine"
}

variable "private_subnet_id" {
    description = "Subnet ID for office environment"
}

variable "vpc_id" {
  description = "The VPC used to launch resources in"
}

variable "security_group_client_id" {
  description = "The security group client id for the client machines"
}