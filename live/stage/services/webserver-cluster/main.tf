module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  aws_region = "ap-southeast-1"
  cluster_name = "webservers-stage"

  db_remote_state_bucket = "infra-state-storage"
  db_remote_state_key = "live/stage/services/data-storage/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2

  private_subnet_cidr = "10.0.1.0/24"

  # Get the values of the input variables from the output variables when you generate the vpc
  public_subnet_id = ""
  vpc_id = ""
}

# Stores the state as a given key in a given bucket on Amazon S3
# Backend config cannot be interpolated, have to key in details manually 
terraform {
  backend "s3" {
    bucket = "infra-state-storage" # S3 bucket created beforehand
    key    = "live/stage/services/webserver-cluster/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = true
    dynamodb_table = "lock-db"
  }
}