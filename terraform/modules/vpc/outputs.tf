output network {
  value       = google_compute_network.vpc_network.id
}

output router_name {
  value       = google_compute_router.nat-router.id
}

output "subnet_id" {
  value = google_compute_subnetwork.subnet1.id
}
