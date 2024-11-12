output sa1 {
  value       = google_service_account.sa1.email
}

output vm_id {
  value       = google_compute_instance.instances.*.id
}

output group {
  value       = google_compute_instance_group.app-instance-group.self_link
}


