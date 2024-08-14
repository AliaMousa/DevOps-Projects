output "iap_access_policy" {
  value = google_project_iam_binding.iap_access.id
}

output "iap_instance_policies" {
  value = google_compute_instance_iam_binding.iap_instance.*.id
}
