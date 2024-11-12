#Configuring IAP tunnels for interacting with instances
#1. Connect to a Compute Engine instance using the IAP tunnel.
#2. Add a second user with IAP tunneling permission in IAM.


#Allows management of a single API service for a Google Cloud project.
resource "google_project_service" "iap-api" {
  project = var.project
  service = "iap.googleapis.com"
  #disable_on_destroy = true
}

#Assign IAM Roles to Users ??I am the admin why should i give me this role??
resource "google_project_iam_binding" "project" {
  project = var.project
  role    = "roles/iap.tunnelResourceAccessor"

  members = [
    "user:your email",
  ]
}

#this block not required in case tcp
/*resource "google_compute_project_metadata" "enable_oslogin" {
  project = var.project

  metadata = {
    enable-oslogin = "TRUE"
  }
}*/


##Assign the role to the service account