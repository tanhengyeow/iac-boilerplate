provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_vpc" "office" {
    cidr_block = "${var.vpc_cidr}"
#    enable_dns_hostnames = true
    tags {
        Name = "office-vpc"
    }
}

resource "aws_internet_gateway" "office-default" {
    vpc_id = "${aws_vpc.office.id}"
    tags {
        Name = "office-vpc-gateway"
    }
}

# ================= NAT Config =====================

resource "aws_security_group" "office_nat" {
    name = "office_vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    vpc_id = "${aws_vpc.office.id}"

    tags {
        Name = "office-nat-sg"
    }
}

resource "aws_security_group_rule" "allow_http_inbound_private-subnet" {
  type              = "ingress"
  security_group_id = "${aws_security_group.office_nat.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["${var.private_subnet_cidr}"]
}

resource "aws_security_group_rule" "allow_http_outbound_anywhere" {
  type              = "egress"
  security_group_id = "${aws_security_group.office_nat.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_outbound_anywhere" {
  type              = "egress"
  security_group_id = "${aws_security_group.office_nat.id}"

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "office_nat" {
    ami = "ami-36af2055" # ami preconfigured for NAT
    availability_zone = "ap-southeast-1a"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.office_nat.id}"]

    subnet_id = "${aws_subnet.ap-southeast-1a-office-public.id}"

    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "office-vpc-nat"
    }
}

# ================= Public Subnet =====================

resource "aws_subnet" "ap-southeast-1a-office-public" {
    vpc_id = "${aws_vpc.office.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "ap-southeast-1a"

    tags {
        Name = "office-public-subnet"
    }
}

resource "aws_route_table" "ap-southeast-1a-office-public" {
    vpc_id = "${aws_vpc.office.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.office-default.id}"
    }

    tags {
        Name = "public-subnet"
    }
}

resource "aws_route_table_association" "ap-southeast-1a-office-public" {
    subnet_id = "${aws_subnet.ap-southeast-1a-office-public.id}"
    route_table_id = "${aws_route_table.ap-southeast-1a-office-public.id}"
}

# ================= Private Subnet =====================

resource "aws_subnet" "ap-southeast-1a-office-private" {
    vpc_id = "${aws_vpc.office.id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "ap-southeast-1a"

    tags {
        Name = "office-private-subnet"
    }
}

resource "aws_route_table" "ap-southeast-1a-office-private" {
    vpc_id = "${aws_vpc.office.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.office_nat.id}"
    }

    tags {
        Name = "office-private-subnet"
    }
}

resource "aws_route_table_association" "ap-southeast-1a-office-private" {
    subnet_id = "${aws_subnet.ap-southeast-1a-office-private.id}"
    route_table_id = "${aws_route_table.ap-southeast-1a-office-private.id}"
}