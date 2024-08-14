/*variable "num_instances" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}*/
variable "vm_name" {
  type        = string
  default     = "app_instance"
  description = "description"
}


/*variable "add_hostname_suffix" {
  description = "Whether to add a suffix to the hostname"
  type        = bool
  default     = false
}*/

/*variable "hostname_suffix_separator" {
  description = "Separator between hostname and suffix"
  type        = string
  default     = "-"
}*/

variable "project_id" {
  description = "The project ID to deploy resources"
  type        = string
}

variable "zone" {
  description = "The zone to deploy resources"
  type        = string
}

variable "deletion_protection" {
  description = "Enable deletion protection on the instance"
  type        = bool
  default     = true
}

/*variable "labels" {
  description = "Labels to apply to instances"
  type        = map(string)
  default     = {}
}*/

variable "network_name" {
  description = "The VPC network name"
  type        = string
  #default  = google_compute_network.network.name
}

variable "subnetwork_name" {
  description = "The subnetwork name"
  type        = string
  #default = google_compute_subnetwork.subnetwork.subnetwork_name
}


variable "subnetwork_project" {
  description = "The project ID of the subnetwork"
  type        = string
  default     = null
}


variable "scopes" {
  description = "Scopes to apply to the service account"
  type        = list(string)
  default     = ["cloud-platform"]
}

variable "vmdb_name" {
  type        = string
  default     = "app_instance"
  description = "description"
}

variable "count_num" {
  type        = number
  default     = 2
  description = "number of instances"
}


variable "group_name" {
  type        = string
  default     = "instances_group"
  description = "description"
}
