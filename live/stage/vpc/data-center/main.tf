module "data_center" {
  source = "../../../../modules/vpc/data-center"

  aws_region = "ap-southeast-1"
  ami = "ami-c352e8a0" # Ubuntu 16.04 LTS
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidr = "10.0.0.0/24"
  private_subnet_cidr_1 = "10.0.1.0/24"
  private_subnet_cidr_2 = "10.0.2.0/24"
}

# Stores the state as a given key in a given bucket on Amazon S3
# Backend config cannot be interpolated, have to key in details manually 
terraform {
  backend "s3" {
    bucket = "infra-state-storage" #S3 bucket created beforehand
    key    = "live/stage/vpc/data-center/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = true
    dynamodb_table = "lock-db"
  }
}