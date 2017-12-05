provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_vpc" "data_center" {
    cidr_block = "${var.vpc_cidr}"
#    enable_dns_hostnames = true
    tags {
        Name = "infra-vpc"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.data_center.id}"
    tags {
        Name = "infra-vpc-gateway"
    }
}

# ================= NAT Config =====================

resource "aws_security_group" "nat" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    vpc_id = "${aws_vpc.data_center.id}"

    tags {
        Name = "nat-sg"
    }
}

resource "aws_security_group_rule" "allow_http_inbound_private-subnet" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nat.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["${var.private_subnet_cidr_1}"]
}

resource "aws_security_group_rule" "allow_https_inbound_private-subnet" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nat.id}"

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["${var.private_subnet_cidr_1}"]
}

resource "aws_security_group_rule" "allow_http_outbound_anywhere" {
  type              = "egress"
  security_group_id = "${aws_security_group.nat.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_outbound_anywhere" {
  type              = "egress"
  security_group_id = "${aws_security_group.nat.id}"

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "nat" {
    ami = "ami-36af2055" # ami preconfigured for NAT
    availability_zone = "ap-southeast-1a"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]

    subnet_id = "${aws_subnet.ap-southeast-1a-public.id}"

    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "vpc-nat"
    }
}

# ================= Public Subnet =====================

resource "aws_subnet" "ap-southeast-1a-public" {
    vpc_id = "${aws_vpc.data_center.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "ap-southeast-1a"

    tags {
        Name = "public-subnet"
    }
}

resource "aws_route_table" "ap-southeast-1a-public" {
    vpc_id = "${aws_vpc.data_center.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "public-subnet"
    }
}

resource "aws_route_table_association" "ap-southeast-1a-public" {
    subnet_id = "${aws_subnet.ap-southeast-1a-public.id}"
    route_table_id = "${aws_route_table.ap-southeast-1a-public.id}"
}

# ================= Private Subnet =====================

resource "aws_subnet" "ap-southeast-1a-private" {
    vpc_id = "${aws_vpc.data_center.id}"

    cidr_block = "${var.private_subnet_cidr_1}"
    availability_zone = "ap-southeast-1a"

    tags {
        Name = "private-subnet"
    }
}

resource "aws_route_table" "ap-southeast-1a-private" {
    vpc_id = "${aws_vpc.data_center.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }

    tags {
        Name = "private-subnet"
    }
}

resource "aws_route_table_association" "ap-southeast-1a-private" {
    subnet_id = "${aws_subnet.ap-southeast-1a-private.id}"
    route_table_id = "${aws_route_table.ap-southeast-1a-private.id}"
}

resource "aws_subnet" "ap-southeast-1b-private" {
    vpc_id = "${aws_vpc.data_center.id}"

    cidr_block = "${var.private_subnet_cidr_2}"
    availability_zone = "ap-southeast-1b"

    tags {
        Name = "private-subnet"
    }
}

resource "aws_route_table" "ap-southeast-1b-private" {
    vpc_id = "${aws_vpc.data_center.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }

    tags {
        Name = "private-subnet"
    }
}

resource "aws_route_table_association" "ap-southeast-1b-private" {
    subnet_id = "${aws_subnet.ap-southeast-1b-private.id}"
    route_table_id = "${aws_route_table.ap-southeast-1b-private.id}"
}