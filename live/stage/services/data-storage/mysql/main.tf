module "mysql_database" {
  source = "../../../../../modules/services/mysql"

  aws_region = "ap-southeast-1"
  public_subnet_cidr = "10.0.0.0/24"
  db_password="${var.db_password}"

  # Get the values from the output variables when you generate the vpc for the next 3 input variables
  # Two subnets required to create db_subnet_group
  private_subnet_id_1a = "" 
  private_subnet_id_1b = "" 
  vpc_id = "" 
}

# Stores the state as a given key in a given bucket on Amazon S3
# Backend config cannot be interpolated, have to key in details manually 
terraform {
  backend "s3" {
    bucket = "infra-state-storage" #S3 bucket created beforehand
    key    = "live/stage/services/data-storage/mysql/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = true
    dynamodb_table = "lock-db"
  }
}