output "global_address" {
  description = "The global address"
  value       = google_compute_address.global_address.address
}

output "instance_group_self_link" {
  description = "Self link of the instance group"
  value       = google_compute_instance_group.instance_group.self_link
}

output "backend_service_self_link" {
  description = "The self-link of the backend service"
  value       = google_compute_backend_service.default.self_link
}

output "health_check_self_link" {
  description = "The self-link of the health check"
  value       = google_compute_http_health_check.default.self_link
}

output "url_map_self_link" {
  description = "The self-link of the URL map"
  value       = google_compute_url_map.default.self_link
}

output "http_proxy_self_link" {
  description = "The self-link of the HTTP proxy"
  value       = google_compute_target_http_proxy.default.self_link
}

output "forwarding_rule_self_link" {
  description = "The self-link of the global forwarding rule"
  value       = google_compute_global_forwarding_rule.default.self_link
}