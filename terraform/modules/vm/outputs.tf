output "app_instance_name" {
  description = "The names of the created instances"
  value       = google_compute_instance.app_instance.name
}

output "instanceapp_self_links" {
  description = "The self-links of the created instances"
  value       = google_compute_instance.app_instance.self_link
}

/*output "app_ip_address" {
  description = "The self-links of the created instances"
  value       = google_compute_instance.app_instance.ipv4_address
}*/

output "instancedb_self_links" {
  description = "The self-links of the created instances"
  value       = google_compute_instance.db_instance.self_link
}

output "app_instance_ip" {
  description = "The internal IP of the created app instance"
  value       = google_compute_instance.app_instance.network_interface[0].network_ip
}

output "db_instance_ip" {
  description = "The internal IP of the created db instance"
  value       = google_compute_instance.db_instance.network_interface[0].network_ip
}

/*output "service_accout_ {
  value       = ""
  sensitive   = true
  description = "description"
  depends_on  = []
}*/


output "instance_group_name" {
  description = "The name of the instance group."
  value       = google_compute_instance_group.instance_group[*].name
}

output "instance_group_self_link" {
  description = "The self-link of the instance group."
  value       = google_compute_instance_group.instance_group[*].self_link
}

output "instance_group_instances" {
  description = "The list of instances in the instance group."
  value       = flatten([for ig in google_compute_instance_group.instance_group : ig.instances])
}
