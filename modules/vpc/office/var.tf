variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "ap-southeast-1"
}

variable "ami" {
    description = "AMIs by region"
    default = {
        ap-southwest-1 = "ami-c352e8a0" # Ubuntu 16.04 LTS
    }
}

variable "vpc_cidr" {
    description = "CIDR for the entire VPC"
    default = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "192.168.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet 1"
    default = "192.168.1.0/24"
}