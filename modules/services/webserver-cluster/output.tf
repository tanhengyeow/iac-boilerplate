output "elb_dns_name" {
  value = "${aws_elb.load_balancer.dns_name}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.web.name}"
}

output "elb_security_group_id" {
  value = "${aws_security_group.elb.id}"
}

output "web_security_group_id" {
  value = "${aws_security_group.web.id}"
}