variable "address_name" {
  type    = string
  default = "global-address"
}

variable "instance_group_name" {
  description = "Name of the instance group"
  type        = string
  default     = "app_instance_group"
}

variable "zone" {
  description = "The zone where the instance group will be created"
  type        = string
  default = "us-central1-a"
}

/*variable "vm_module" {
  description = "Reference to the vm module to get instance self_links"
  type = object({
    app_instance_self_link = string
    db_instance_self_link  = string
  })
}*/

#comeback here
variable "instance_names" {
  description = "List of self_links of the instances to include in the group"
  type        = list(string)
  
}

variable "backend_service_name" {
  type    = string
  default = "backend-service"
}

variable "health_check_name" {
  type    = string
  default = "http-health-check"
}


variable "url_map_name" {
  type        = string
  default     = "url-map"
  description = "description"
}


variable "http_proxy_name" {
  type    = string
  default = "http-lb-proxy"
}

variable "forwarding_rule_name" {
  type    = string
  default = "global-forwarding-rule"
}

/*variable "instance_names" {
  type        = list(string)
  #default     = ""
  description = "description"
}*/
