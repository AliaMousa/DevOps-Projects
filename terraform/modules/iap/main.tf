# IAM Policy Binding for IAP Access
resource "google_project_iam_binding" "iap_access" {
  project = var.project

  role = "roles/iap.tunnelResourceAccessor"

  members = var.members
}

# IAM Policy Binding for each VM
resource "google_compute_instance_iam_binding" "iap_instance_access" {
  instance = var.app
  project  = var.project
  zone     = each.value

  role    = "roles/iap.tunnelResourceAccessor"
  members = var.members
}

# IAM Policy Binding for each VM
resource "google_compute_instance_iam_binding" "iap_instance_access" {
  instance = var.db
  project  = var.project
  zone     = each.value

  role    = "roles/iap.tunnelResourceAccessor"
  members = var.members
}