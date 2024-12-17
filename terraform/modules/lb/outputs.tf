/*output health-check-id {
  value       = google_compute_health_check.http_health_check.id
}


output backend {
  value       = google_compute_backend_service.backend_service_us.self_link
}


output proxy_id {
    value = google_compute_target_http_proxy.proxy.id
}

output url_map {
    value =  google_compute_url_map.web_map.id
}

*/