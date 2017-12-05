provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "infra-db-subnet"
  subnet_ids = ["${var.private_subnet_id_1a}","${var.private_subnet_id_1b}"]

  tags {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "db" {
  name = "vpc_db"
  description = "Allow incoming database connections"

  vpc_id = "${var.vpc_id}"

  tags {
      Name = "db-sg"
  }
}

resource "aws_security_group_rule" "allow_traffic_inbound_webserver" {
  type              = "ingress"
  security_group_id = "${aws_security_group.db.id}"

  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["${var.public_subnet_cidr}"]
}

resource "aws_security_group_rule" "allow_http_outbound_anywhere" {
  type              = "egress"
  security_group_id = "${aws_security_group.db.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_outbound_anywhere" {
  type              = "egress"
  security_group_id = "${aws_security_group.db.id}"

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_db_instance" "webserver_db" {
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "webserverDB"
  username          = "admin"
  password          = "${var.db_password}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  availability_zone = "ap-southeast-1a"
  db_subnet_group_name = "${aws_db_subnet_group.db_subnet.name}"
  skip_final_snapshot = true
}