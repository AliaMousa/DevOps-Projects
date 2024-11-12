resource "google_compute_network" "vpc_network" {
  name                    = var.name
  auto_create_subnetworks = var.auto_create_subnetworks
  project = var.project
}

resource "google_compute_subnetwork" "subnet1" {
  name             = var.subnet1
  region           = var.region
  ip_cidr_range    = var.ip_cidr_range
  #purpose          = "PRIVATE_NAT"
  network          =  google_compute_network.vpc_network.id
  project = var.project
}

resource "google_compute_firewall" "allow-ssh-form-iap" {
  name    = var.firewall_name
  network = google_compute_network.vpc_network.id
  project = var.project
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]

  target_tags = ["app", "db"]

  direction = "INGRESS"
  depends_on = [google_compute_network.vpc_network]
}


  resource "google_compute_firewall" "http" {
  name          = "allow-lb-and-healthcheck"
  network       = google_compute_network.vpc_network.id
  project       = var.project
  target_tags   = ["app"]

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16", 
  ]

  allow {
    protocol    = "tcp"
    ports       = ["80",]
  }
}


## the following is for Building internet connectivity for private VMs
resource "google_compute_router" "nat-router" {
  name    = var.router_name
  network = google_compute_network.vpc_network.id
  project = var.project
  region  = var.region
}

/*
Create a NAT configuration named nat-config.
Apply NAT to the router nat-router-us-central1.
Automatically allocate IPs for the NAT.
Apply NAT to all subnets in the network.
*/
resource "google_compute_router_nat" "nat_config" {
  name   = var.nat_config_name
  router = "${google_compute_router.nat-router.name}"#google_compute_router.nat-router.name
  region = google_compute_router.nat-router.region

  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  #depends_on = [google_compute_router.nat-router]
  project = var.project
}
