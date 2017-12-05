output "instance_id" {
  value = ["${aws_instance.client_machine.*.id}"]
}

output "private_ip" {
  value = ["${aws_instance.client_machine.*.private_ip}"]
}

output "subnet_id" {
  value = ["${aws_instance.client_machine.*.subnet_id}"]
}