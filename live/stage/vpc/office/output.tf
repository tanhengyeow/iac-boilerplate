output "vpc_id" {
  value = "${module.office_environment.vpc_id}"
}

output "gateway_id" {
  value = "${module.office_environment.gateway_id}"
}

output "public_subnet_id" {
  value = "${module.office_environment.public_subnet_id}"
}

output "private_subnet_id" {
  value = "${module.office_environment.private_subnet_id}"
}