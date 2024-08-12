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

  dynamic "network_interface" {
    for_each = var.network_interface

    content {
      network            = var.network
      subnetwork         = var.subnetwork
      subnetwork_project = var.subnetwork_project
      #network_ip         = length(var.static_ips) == 0 ? null : element(var.static_ips, count.index)

      dynamic "access_config" {
        for_each = var.access_config
        content {
          nat_ip = null
        }
      }
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

  dynamic "network_interface" {
    for_each = var.network_interface

    content {
      network            = var.network
      subnetwork         = var.subnetwork
      subnetwork_project = var.subnetwork_project
      #network_ip         = length(var.static_ips) == 0 ? null : element(var.static_ips, count.index)

      dynamic "access_config" {
        for_each = var.access_config
        content {
          nat_ip = null
        }
      }
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
