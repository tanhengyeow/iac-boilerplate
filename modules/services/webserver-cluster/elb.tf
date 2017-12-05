# ===================== ELB Config ========================

# Custom security group to allow incoming and outgoing traffic (for ELB)
resource "aws_security_group" "elb" {
  name = "${var.cluster_name}-elb"

  vpc_id = "${var.vpc_id}"
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_http_inbound_elb" {
  type              = "ingress"
  security_group_id = "${aws_security_group.elb.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound_elb" {
  type              = "egress"
  security_group_id = "${aws_security_group.elb.id}"

  # Allow outbound requests for health checks
  # If you select a protocol of "-1" (semantically equivalent to "all", which is not a valid value here), you must specify a "from_port" and "to_port" equal to 0. If not icmp, tcp, udp, or "-1" use the protocol number
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
 
# Elastic Load Balancer
resource "aws_elb" "load_balancer" {

  name = "${var.cluster_name}-load-balancer"
  security_groups = ["${aws_security_group.elb.id}"]
  subnets = ["${var.public_subnet_id}"]
  
  # Periodically check the health of your EC2 Instances and, if an instance is unhealthy, it will automatically stop routing traffic to it
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }

  # Specifies what port the ELB should listen on and what port it should route the request to
  # In this case, route to port used by instances in ASG
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }

  lifecycle {
    create_before_destroy = true
  }
}