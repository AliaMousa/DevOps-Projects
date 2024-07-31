#Rewrite this file by Modules
locals {
  project_id = "devops_project1"
  network = "app-network"
  ssh_user = "ansible"
  private_key_path = "./.ssh/rsa_pub"
}


provider "google" {
  project = local.project_id
  region = "*****"
}

resource "google_service_account" "service_account" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_compute_network" "vpc_network" {
  project                 = local.project_id
  name                    = "app-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  name = "app_subnetwork"
  ip_cidr_range = "10.0.0.0/28"
  region = local.region
  network = google_compute_network.app_network.id
  purpose       = "PRIVATE_NAT"
}

resource "google_compute_router" "router" {
  name    = "app-router"
  network = google_compute_network.app_network.name
  bgp {
    asn               = 64514
    }
}

resource "google_compute_router_nat" "nat_type" {
  name                                = "app-router-nat"
  router                              = google_compute_router.router.name
  region                              = local.region
  source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"
  enable_dynamic_port_allocation      = false
  enable_endpoint_independent_mapping = false
  type                                = "PRIVATE"
}

resource "google_compute_firewall" "app_firewall" {
  name    = "test-firewall"
  network = google_compute_network.app_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_tags = ["app", "db"]
}

resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "vm_instance" {
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

    access_config {
      // Ephemeral public IP
      nat_ip {

      }
    }
  }

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

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    vm = "database"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}


