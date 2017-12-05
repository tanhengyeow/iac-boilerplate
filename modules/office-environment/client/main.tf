provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_instance" "client_machine" {
  count = "${var.instance_number}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${var.security_group_client_id}"]
  subnet_id = "${var.private_subnet_id}"

  tags = {
    Name = "${var.client_name}.${count.index}"
  }
}