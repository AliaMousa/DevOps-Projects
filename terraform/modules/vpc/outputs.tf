output "network" {
  value       = google_compute_network.network
  description = "The VPC resource being created"
}

output "network_name" {
  value       = google_compute_network.network.name
  description = "The name of the VPC being created"
}

output "network_id" {
  value       = google_compute_network.network.id
  description = "The ID of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.network.self_link
  description = "The URI of the VPC being created"
}

output "subnets" {
  value       = google_compute_subnetwork.subnetwork
  description = "The created subnet resources"
}

output "subnet_name" {
  value       = google_compute_subnetwork.subnetwork.name
  description = "The created subnet resources"
}

output "firewall_rules" {
  value       = google_compute_firewall.rules
  description = "The created firewall rule resources"
}

output "router_name" {
  value       = google_compute_router.router
  description = "The name of the route being created"
}

