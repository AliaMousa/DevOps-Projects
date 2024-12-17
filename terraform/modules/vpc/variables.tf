variable name {
  type        = string
}

variable project {
  type        = string
}


variable auto_create_subnetworks {
  type        = bool
  default = false
}

variable subnet1 {
  type        = string
}

variable region {
  type        = string
}

variable ip_cidr_range {
  type        = string
  default     = "10.0.0.0/24"
}

variable firewall_name {
  type        = string
  default     = "allow-ssh-form-iap"
}

variable router_name {
  type        = string
  default     = "nat-router"
}

variable nat_config_name {
  type        = string
  default     = "nat-config"
}
