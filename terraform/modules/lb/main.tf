/*
Global forwarding rules route traffic by IP address, port, and protocol to a load balancing configuration consisting of a target proxy, URL map, and one or more backend services.
Target proxies terminate HTTP(S) connections from clients. One or more global forwarding rules direct traffic to the target proxy, and the target proxy consults the URL map to determine how to route traffic to backends.
URL maps define matching patterns for URL-based routing of requests to the appropriate backend services. A default service is defined to handle any requests that do not match a specified host rule or path matching rule.
Backends are resources to which a GCP load balancer distributes traffic. These include backend services, such as instance groups or backend buckets.


#health_check
#This resource defines a template for how individual VMs should be checked for health, via HTTP.
resource "google_compute_health_check" "http-health-check" {
  name = "http-health-check"

  timeout_sec        = 5
  check_interval_sec = 5

  http_health_check {
    port = 80
  }
}

#Backend service
resource "google_compute_backend_service" "app_backend_service" {
  name          = "backend-service"
  health_checks = [google_compute_health_check.http-health-check.self_link]
  protocol      = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  region        = var.region # Add region for regional resource
  backend {
    group = var.instance_group # Ensure this variable is a self_link to the regional instance group
  }
}

# Regional forwarding rule
resource "google_compute_forwarding_rule" "ipv4-forwarding-rule" {
  name                  = "http-proxy-xlb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.http-proxy.id # Regional proxy
  #region                = var.region # Specify the region
  # Uncomment this line if you want to use a static IP address
  # ip_address           = google_compute_address.default.id
}

# Regional URL map
resource "google_compute_region_url_map" "app-url-map" {
  name            = "url-map"
  #region          = var.region
  default_service = google_compute_backend_service.app_backend_service.self_link
  depends_on      = [google_compute_backend_service.app_backend_service]
}

# Regional target proxy
# Used by one or more forwarding rules to route incoming HTTP requests to a URL map.
resource "google_compute_region_target_http_proxy" "http-proxy" {
  name    = "test-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.app-url-map.id
}

*/
/*
resource "google_compute_forwarding_rule" "ipv4_rule" {
  name       = "ipv4-forwarding-rule"
  ip_version = "IPV4"
  target     = google_compute_target_http_proxy.proxy.self_link
  ip_protocol           = "TCP"          # Correct the protocol
  port_range            = "80"            # Specify the correct port for HTTP traffic

}


resource "google_compute_target_http_proxy" "proxy" {
  name      = "https-proxy"
  url_map   = google_compute_url_map.web_map.self_link
  #ssl_certificates = [google_compute_ssl_certificate.default.self_link]
}

resource "google_compute_url_map" "web_map" {
  name            = "web-map"
  default_service = google_compute_backend_service.backend_service_us.self_link
}

resource "google_compute_backend_service" "backend_service_us" {
  name         = "us-backend-service"
  backend {
    group = var.group
  }
  health_checks = [google_compute_health_check.http_health_check.self_link]
}


resource "google_compute_health_check" "http_health_check" {
  name               = "health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 2
  tcp_health_check {
    port = 80
  }
}
*/

/*resource "google_compute_health_check" "http_health_check" {
  name               = "http-health-check"
  timeout_sec        = 5
  check_interval_sec = 5

  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "app_backend_service" {
  name               = "backend-service"
  protocol           = "HTTP"
  health_checks      = [google_compute_health_check.http_health_check.self_link]
  load_balancing_scheme = "EXTERNAL"
  
  backend {
    group = var.instance_group  # This should refer to a regional instance group
  }
  
  #region = var.region  # Specify the region
}

resource "google_compute_region_url_map" "app_url_map" {
  name            = "url-map"
  region          = var.region
  default_service = google_compute_backend_service.app_backend_service.self_link

  depends_on = [google_compute_backend_service.app_backend_service]
}

resource "google_compute_region_target_http_proxy" "proxy" {
  name    = "test-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.app_url_map.self_link
}

resource "google_compute_forwarding_rule" "ipv4_rule" {
  name                  = "ipv4-forwarding-rule"
  region                = var.region  # Specify the region
  ip_version            = "IPV4"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_region_target_http_proxy.proxy.self_link
  ip_protocol           = "TCP"
  port_range            = "80"  # Or use "443" for HTTPS
}
*/

resource "google_compute_health_check" "app_health_check" {
  name               = "app-health-check"
  description        = ""
  check_interval_sec = 5
  healthy_threshold  = 2
  unhealthy_threshold = 2
  timeout_sec        = 5

  http_health_check {
    port         = 80
    request_path = "/"
    proxy_header = "NONE"
  }
}

# Backend Service
resource "google_compute_backend_service" "app_backend_service" {
  name                  = "app-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  
  # Health check for the backend service
  health_checks = [google_compute_health_check.app_health_check.self_link]

  # Backend (instance group)
  backend {
    group = var.group #google_compute_instance_group.app_instance_group.self_link
  }
}

# URL Map for Backend Service
resource "google_compute_url_map" "app_url_map" {
  name            = "app-url-map"
  default_service = google_compute_backend_service.app_backend_service.self_link
  depends_on = []
}

# Target HTTP Proxy
resource "google_compute_target_http_proxy" "app_http_proxy" {
  name    = "app-http-proxy"
  url_map = google_compute_url_map.app_url_map.self_link
}

# Global Forwarding Rule (IPv4)
resource "google_compute_global_forwarding_rule" "app_forwarding_rule" {
  name                  = "http-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_http_proxy.app_http_proxy.self_link
  port_range            = "80"
  ip_version            = "IPV4"  # IP address selection policy (IPv4 only)
}