output "instance_names" {
  description = "The names of the created instances"
  value       = google_compute_instance.compute_instance.*.name
}

output "instance_self_links" {
  description = "The self-links of the created instances"
  value       = google_compute_instance.app_instance.self_link
}

output "instance_self_links" {
  description = "The self-links of the created instances"
  value       = google_compute_instance.db_instance.self_link
}

output "instance_ips" {
  description = "The internal IPs of the created instances"
  value       = google_compute_instance.compute_instance.*.network_interface[0].network_ip
}