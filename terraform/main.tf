locals {
  project_id = "frist_project"
  zone       = "us-central1-a"
}

module "vpc" {
  source       = "./modules/vpc"
  project_id   = "<PROJECT ID>"
  network_name = "example-vpc"
}

module "vm" {
  source     = "./modules/vm"
  project_id = "frist_project"
  zone       = "us-central1-a"
  network_name = google_compute_network.network.name
  subnetwork_name = google_compute_subnetwork.subnetwork.subnetwork_name
}

module "lb" {
  source = "./modules/lb"
  instance_names = [
    module.vm.app_instance.self_link,
    var.google_compute_instance.db_instance.self_link
  ]
}