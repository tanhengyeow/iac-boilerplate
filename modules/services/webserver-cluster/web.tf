# ================= Web Servers Config ==================

# Custom security group to allow incoming and outgoing traffic (for web servers)
resource "aws_security_group" "web" {
  name = "${var.cluster_name}-web"

  vpc_id = "${var.vpc_id}"
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_http_inbound_anywhere" {
  type              = "ingress"
  security_group_id = "${aws_security_group.web.id}"

  from_port   = "${var.server_port}" 
  to_port     = "${var.server_port}"
  protocol    = "tcp"
  #CIDR blocks are a concise way to specify IP address ranges
  #CIDR block 0.0.0.0/0 is an IP address range that includes all possible IP addresses
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_traffic_outbound_dbserver" {
  type              = "egress" # MySQL
  security_group_id = "${aws_security_group.web.id}"

  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["${var.private_subnet_cidr}"]
}