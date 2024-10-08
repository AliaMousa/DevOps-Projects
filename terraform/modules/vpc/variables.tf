variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable region {
  type        = string
  default     = "us-central1-a"
  description = "project region"
}


variable "network_name" {
  description = "The name of the network being created"
  type        = string
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default     = false
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnetwork being created"
  default = "app_subnetwork"
}

variable "subnet_ip" {
  type        = string
  description = "ip cidr range"
  default = "10.10.0.0/28"
}

variable "subnet_region" {
  type    = string
  default = "us-central1"
}

variable "private_ip_google_access" {
  type    = bool
  default = true
}

variable "purpose" {
  type    = string
  default = "PRIVATE_NAT"
}

variable "rule_name" {
  type        = string
  description = "rule name"
  default     = "allow_ssh_http"
}

variable "description" {
  type        = string
  description = "firewall rule to allow ssh and http"
  default     = "allow ssh and http"
}

variable "source_ranges" {
  type    = list(string)
  default = ["35.235.240.0/20"]

}

variable "target_tags" {
  description = "A list of source tags"
  type        = list(string)
  default     = ["db", "app"]
}

variable "rules" {
  type = list(object({
    protocol = string
    ports    = optional(list(string))
  }))
  default = []
}

variable "router_name" {
  type        = string
  default     = "router_app"
  description = "Router"

}

variable "router_nat" {
  type    = string
  default = "app_nat"

}

variable "port_allocation" {
  type    = bool
  default = false
}

variable "endpoint_mapping" {
  type    = bool
  default = false

}



