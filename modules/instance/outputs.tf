output "name" {
  value = "${var.name}"
}

output "nodes_private_ip" {
  value = yandex_compute_instance.instance.*.network_interface.0.ip_address
}

output "nodes_public_ip" {
  value = yandex_compute_instance.instance.*.network_interface.0.nat_ip_address
}