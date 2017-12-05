provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.bucket_name}"

  versioning {
    enabled = false # set this to true if you are provisioning this bucket for important operations
  }

  force_destroy = true # delete this line if you are provisioning this bucket for important operations
}