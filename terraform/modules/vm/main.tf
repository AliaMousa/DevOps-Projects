resource "google_compute_instance" "app_instance" {
  provider            = google
  #count               = var.num_instances
  #name                = var.add_hostname_suffix ? format("%s%s%s", var.hostname, var.hostname_suffix_separator, format("%03d", count.index + 1)) : var.hostname
  name = var.vm_name
  project             = var.project_id
  zone                = var.zone
  deletion_protection = var.deletion_protection
  machine_type        = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = var.network_name
    subnetwork = var.subnetwork_name
    access_config {
      nat_ip = null
        }
      }


  /*metadata = {
    ssh-keys = "path/to/ssh/public/key"
  }*/

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
 }
}

resource "google_service_account" "default" {
  project      = var.project_id
  account_id   = "default-service-account"
  display_name = "Default Service Account"
}


resource "google_compute_instance" "db_instance" {
  provider            = google
  #count               = var.num_instances
  #name                = var.add_hostname_suffix ? format("%s%s%s", var.hostname, var.hostname_suffix_separator, format("%03d", count.index + 1)) : var.hostname
  name = var.vmdb_name
  project             = var.project_id
  zone                = var.zone
  deletion_protection = var.deletion_protection
  machine_type        = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = var.network_name
    subnetwork = var.subnetwork_name
    access_config {
      nat_ip = null
        }
      }


  /*metadata = {
    ssh-keys = "path/to/ssh/public/key"
  }*/

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
 }
}


resource "google_compute_instance_group" "instance_group" {
  provider = google
  count    = var.count_num
  name     = var.group_name
  project  = var.project_id
  zone     = var.zone
  instances = [
    google_compute_instance.app_instance.self_link,
    google_compute_instance.db_instance.zone
  ]
}