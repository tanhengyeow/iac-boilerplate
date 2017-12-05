provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "client" {
  name = "vpc_client"

  vpc_id = "${var.vpc_id}"

  tags {
      Name = "client-sg"
  }
}

resource "aws_security_group_rule" "allow_http_outbound_anywhere" {
  type              = "egress"
  security_group_id = "${aws_security_group.client.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_outbound_anywhere" {
  type              = "egress"
  security_group_id = "${aws_security_group.client.id}"

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}