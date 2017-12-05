module "linux_client" {
  source = "../../../../modules/office-environment/client"

  aws_region = "ap-southeast-1"
  ami = "ami-ee0eb98d" # Ubuntu 16.04 LTS
  instance_type = "t2.micro"
  instance_number =  2
  client_name = "linux_client"

  # Get the values of the input variables from the output variables when you generate office-environment security group
  security_group_client_id = ""

  # Get the values of the input variables from the output variables when you generate the vpc
  private_subnet_id = ""
  vpc_id = ""
}

module "windows_client" {
  source = "../../../../modules/office-environment/client"

  aws_region = "ap-southeast-1"
  ami = "ami-528db200" # Windows 7
  instance_type = "t2.micro"
  instance_number =  2
  client_name = "windows_client"

  # Get the values of the input variables from the output variables when you generate office-environment security group
  security_group_client_id = ""
  
  # Get the values of the input variables from the output variables when you generate the vpc
  private_subnet_id = ""
  vpc_id = ""
}

# Stores the state as a given key in a given bucket on Amazon S3
# Backend config cannot be interpolated, have to key in details manually 
terraform {
  backend "s3" {
    bucket = "infra-state-storage" # S3 bucket created beforehand
    key    = "live/stage/office-environment/client/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = true
    dynamodb_table = "lock-db"
  }
}