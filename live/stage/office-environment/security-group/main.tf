module "security_group" {
  source = "../../../../modules/office-environment/security-group"

  aws_region = "ap-southeast-1"

  # Get the values of the input variables from the output variables when you generate the vpc
  vpc_id = ""
}

# Stores the state as a given key in a given bucket on Amazon S3
# Backend config cannot be interpolated, have to key in details manually 
terraform {
  backend "s3" {
    bucket = "infra-state-storage" # S3 bucket created beforehand
    key    = "live/stage/office-environment/security-group/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = true
    dynamodb_table = "lock-db"
  }
}