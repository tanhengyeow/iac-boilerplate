provider "aws" {
  region = "${var.aws_region}"
}

# Declare the data source (The Availability Zones data source allows access to the list of AWS Availability Zones which can be accessed by an AWS account within the region configured in the provider)
# data "aws_availability_zones" "all" {}

#This terraform_remote_state data source configures the web server cluster code to read the state file from the same S3 bucket and folder where the database stores its state
data "terraform_remote_state" "db" {
  backend = "s3"
  config {
    bucket = "${var.db_remote_state_bucket}"
    key    = "${var.db_remote_state_key}"
    region = "${var.aws_region}"
  }
}

# Renders a template from a file
data "template_file" "user_data" {

  #template variable is a string
  template = "${file("${path.module}/user-data.sh")}" 

  # map of variables
  vars {
    server_port = "${var.server_port}"
    db_address  = "${data.terraform_remote_state.db.address}"
    db_port     = "${data.terraform_remote_state.db.port}"
  }
}