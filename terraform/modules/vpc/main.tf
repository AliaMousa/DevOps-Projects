
/******************************************
	VPC configuration
 *****************************************/
resource "google_compute_network" "network" {
  name                    = var.network_name
  auto_create_subnetworks = var.auto_create_subnetworks
  project                 = var.project_id
}

resource "google_compute_subnetwork" "subnetwork" {

  name                     = var.subnet_name
  ip_cidr_range            = var.subnet_ip
  region                   = var.subnet_region
  private_ip_google_access = var.private_ip_google_access
  network                  = var.network_name
  project                  = var.project_id
  purpose                  = var.purpose

}

resource "google_compute_firewall" "rules" {
  name        = var.rule_name
  description = var.description

  network       = var.network_name
  project       = var.project_id
  source_ranges = var.source_ranges
  #source_tags             = each.value.source_tags
  #source_service_accounts = each.value.source_service_accounts
  target_tags = var.target_tags

  dynamic "allow" {
    #for_each = lookup(each.value, "allow", [])
    content {
      protocol = ssh
      ports    = 22
    }
  }
}

resource "google_compute_router" "router" {


  project = var.project_id
  network = var.network_name
  name    = var.router_name

}

resource "google_compute_router_nat" "nat_router" {
  name   = var.router_nat
  router = google_compute_router.router.name
  region = local.region
  #source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"
  enable_dynamic_port_allocation      = var.port_allocation
  enable_endpoint_independent_mapping = var.endpoint_mapping
}