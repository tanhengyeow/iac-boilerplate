variable "aws_region" {
  default = "ap-southeast-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  default = "infra-state-storage"
}