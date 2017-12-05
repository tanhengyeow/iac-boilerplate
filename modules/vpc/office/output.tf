output "vpc_id" {
  value = "${aws_vpc.office.id}"
}

output "gateway_id" {
  value = "${aws_internet_gateway.office-default.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.ap-southeast-1a-office-public.id}"
}

output "private_subnet_id" {
  value = "${aws_subnet.ap-southeast-1a-office-private.id}"
}