output "vpc_id" {
  value = "${aws_vpc.data_center.id}"
}

output "gateway_id" {
  value = "${aws_internet_gateway.default.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.ap-southeast-1a-public.id}"
}

output "private_subnet_id_1a" {
  value = "${aws_subnet.ap-southeast-1a-private.id}"
}

output "private_subnet_id_1b" {
  value = "${aws_subnet.ap-southeast-1b-private.id}"
}