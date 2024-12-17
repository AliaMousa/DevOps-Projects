variable vm_name {
  type        = list
  default     = ["app-instance", "db-instance"]
}

variable "account_id" {
  type = string
  default = "sa1-custum-for-vm"
} 

variable project {
  type        = string
}

variable zone {
  type        = string
}

/*variable deletion_protection {
  type        = bool
  default     = true
}*/

variable machine_type {
  type        = string
  default     = "e2-medium"
}

variable network {
  type        = string
}

variable subnetwork {
  type        = string
}

variable instances {
  type        = list(string)
}

variable group_name {
  type        = string
  default     = "my-app-instance-group"
}

variable "vm_labels" {
  type    = list(map(string))
  default = [
    { environment = "dev", machine = "app" },
    { environment = "dev", machine = "db" }
  ]
}