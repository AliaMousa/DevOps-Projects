resource "google_compute_address" "global_address" {
  name    = var.address_name
  purpose = "Global"
}

resource "google_compute_instance_group" "instance_group" {
  name = var.instance_group_name
  zone = var.zone

  instances = var.instance_names
}

resource "google_compute_backend_service" "default" {
  name                  = var.backend_service_name
  port_name             = "http"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_http_health_check.default.self_link]

  backend {
    group = google_compute_instance_group.instance_group.self_link
  }
}

resource "google_compute_http_health_check" "default" {
  name         = var.health_check_name
  request_path = "/"
}

resource "google_compute_url_map" "default" {
  name            = var.url_map_name
  default_service = google_compute_backend_service.default.self_link
}

resource "google_compute_target_http_proxy" "default" {
  name    = var.http_proxy_name
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = var.forwarding_rule_name
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"
  ip_address = google_compute_address.global_address.address
}