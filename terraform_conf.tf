#Rewrite this file by Modules
locals {
  project_id = "devops_project1"
  #network = "app-network"
  ssh_user = "ansible"
  private_key_path = "./.ssh/rsa_pub"
}


provider "google" {
  project = local.project_id
  region = "us-west1"
}

resource "google_service_account" "service_account" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

# the first step in the task is creating vpc network 
resource "google_compute_network" "vpc_network" {
  project                 = local.project_id
  name                    = "app-network"
  auto_create_subnetworks = false
}

# the second step is to create custom subnet, the required properties is network name, subnet name, region and ipv4 addresses range and also we should Enable Private Google Access
resource "google_compute_subnetwork" "private_subnet" {
  name = "app_subnetwork"
  ip_cidr_range = "10.10.0.0/28"
  region = local.region
  network = google_compute_network.app_network.id
  purpose       = "PRIVATE_NAT"
  private_ip_google_access = true
}

# then we sould create the firewall rule to allow ssh protocol Targets may be all instances in the network or we can target tags
resource "google_compute_firewall" "allow_ssh_rule" {
  name    = "allow_ssh_rule"
  network = google_compute_network.app_network.name

  #allow {
   # protocol = "icmp"
  #}

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["app", "db", "web"]
}
# comeback to this resource again and make sure to add the ssh_key
# then We should create 2 Instances app_instance and db_instance, all of both should have no external ip and associated with the custom private subnet.
resource "google_compute_instance" "vm_instance1" {
  name         = "app-instance"
  machine_type = "e2-micro"
  zone         = "us-west1-a"

  tags = ["app", "web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = google_compute_network.app_network.id
    subnetwork = google_compute_subnetwork.private_subnet.name

    access_config {
      // should haven't external ip
      nat_ip = null
    }
  }
# -->comeback here again
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "vm_instance2" {
  name         = "db-instance"
  machine_type = "e2-micro"
  zone         = "us-west1-a"

  tags = ["db", "web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = google_compute_network.app_network.id
    subnetwork = google_compute_subnetwork.private_subnet.name

    access_config {
      // No external ip and This is to enable the instance to reach the internet for package installation
      nat_ip = null
    }
  }

  metadata = {
    vm = "database"
  }
# --> comeback here again
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

# Then we should Configure a Cloud NAT gateway
resource "google_compute_router" "router" {
  name    = "app-router"
  network = google_compute_network.app_network.name
  bgp {
    asn               = 64514
    }
}

resource "google_compute_router_nat" "nat_router" {
  name                                = "app-router-nat"
  router                              = google_compute_router.router.name
  region                              = local.region
  source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"
  enable_dynamic_port_allocation      = false
  enable_endpoint_independent_mapping = false
  type                                = "PRIVATE"
}

# This for service account but we attach the service account for every machine during creating
// resource "google_service_account" "default" {
  //account_id   = "my-custom-sa"
  //display_name = "Custom SA for VM Instance"
//}

# latest step configuring Load Balancing
# Reserve a Global IP Address
resource "google_compute_address" "global_address" {
  name    = "global-address"
  purpose = "GLOBAL"
}

# Create Instance Group for app_instance and db_instance
resource "google_compute_instance_group" "app_instance_group" {
  name = "app-instance-group"
  zone = "us-central1-a"

  instances = [
    google_compute_instance.app_instance.self_link,
    google_compute_instance.db_instance.self_link
  ]
}

# Backend Service with Instances
resource "google_compute_backend_service" "default" {
  name                            = "backend-service"
  port_name                       = "http"
  protocol                        = "HTTP"
  load_balancing_scheme           = "EXTERNAL"
  health_checks                   = [google_compute_http_health_check.default.self_link]

  backend {
    group = google_compute_instance_group.app_instance_group.self_link
  }
}

# Health Check
resource "google_compute_http_health_check" "default" {
  name         = "http-health-check"
  request_path = "/"
}

# URL Map
resource "google_compute_url_map" "default" {
  name            = "url-map"
  default_service = google_compute_backend_service.default.self_link
}

# HTTP Proxy
resource "google_compute_target_http_proxy" "default" {
  name   = "http-lb-proxy"
  url_map = google_compute_url_map.default.self_link
}

# Global Forwarding Rule
resource "google_compute_global_forwarding_rule" "default" {
  name       = "global-forwarding-rule"
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"
  ip_address = google_compute_address.global_address.address
}


# review