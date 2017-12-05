output "elb_dns_name" {
  value = "${module.webserver_cluster.elb_dns_name}"
}

output "asg_name" {
  value = "${module.webserver_cluster.asg_name}"
}

output "elb_security_group_id" {
  value = "${module.webserver_cluster.elb_security_group_id}"
}