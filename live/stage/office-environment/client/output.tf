output "instance_id_linux" {
  value = ["${module.linux_client.instance_id}"]
}

output "instance_id_windows" {
  value = ["${module.windows_client.instance_id}"]
}

output "private_ip_linux" {
  value = ["${module.linux_client.private_ip}"]
}

output "private_ip_windows" {
  value = ["${module.windows_client.private_ip}"]
}