output "vpc_id" {
  value = "${module.data_center.vpc_id}"
}

output "gateway_id" {
  value = "${module.data_center.gateway_id}"
}

output "public_subnet_id" {
  value = "${module.data_center.public_subnet_id}"
}

output "private_subnet_id_1a" {
  value = "${module.data_center.private_subnet_id_1a}"
}

output "private_subnet_id_1b" {
  value = "${module.data_center.private_subnet_id_1b}"
}