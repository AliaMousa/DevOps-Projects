# variables.tf

variable "project" {
  description = "The GCP project ID where the resources will be created"
  type        = string
}

variable "app" {
  description = "A map of instance names to their respective zones"
  type        = string
  default     = google_compute_instance.app_instance.self_link
}

variable "db" {
  description = "A map of instance names to their respective zones"
  type        = string
  default     = google_compute_instance.db_instance.self_link
}

variable "members" {
  description = "List of IAM members (e.g., users or service accounts) that will be granted access"
  type        = list(string)
}
