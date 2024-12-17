resource "google_service_account" "sa1" {
    account_id = var.account_id
    display_name = "Custom SA for VM Instance"
    project = "your_project_id"
}

resource "google_compute_instance" "instances" {
  allow_stopping_for_update = true
  count               = length(var.vm_name)
  name                = var.vm_name[count.index]
  project             = var.project
  zone                = var.zone
  deletion_protection = false #var.deletion_protection
  machine_type        = var.machine_type

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
   }

  network_interface {
    network = var.network
    subnetwork = var.subnetwork
    }
  labels = var.vm_labels[count.index]
  tags = ["app"]

  service_account {
    email  = google_service_account.sa1.email
    scopes = ["cloud-platform"]
  }
  metadata = {
    ssh-keys = "your-ssh-key"
  }

  #provisioner "local-exec" {
   # command = "ansible-playbook /home/alia/GitHub_project/gcp_project/ansible/nginx.yml -i '${google_compute_instance.instances[0].network_interface[0].network_ip},' --user=alia --private-key=~/.ssh/gce_service_account -e 'ansible_ssh_common_args=\"-o ProxyCommand=\\\"gcloud compute ssh ${self.name} --project ${var.project} --zone ${var.zone} --tunnel-through-iap\\\"\"' --timeout=60"
#}

}

resource "google_compute_instance_group" "app-instance-group" {
  name        = var.group_name
  description = "Terraform test instance group"
  project             = var.project
  #project = "your_project_id"
  instances =  [
    google_compute_instance.instances[0].self_link
    #google_compute_instance.instances[1].self_link
    #"google_compute_instance.instances.${vm_name[count.index[0]]}.vm_id" 
   
  ]

  #region = "us-east1"
}