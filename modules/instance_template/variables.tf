variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names."
}

variable "project_id" {
  type        = string
  description = "The GCP project ID."
}

variable "instance_templates" {
  description = "A map of instance templates to create."
  type = map(object({
    name             = string
    region           = string
    data_subnet_name = string
    mgmt_subnet_name = string
  }))
}

variable "machine_type" {
  description = "The machine type for the instances in the template."
  type        = string
}

variable "boot_disk_image" {
  description = "The boot disk image for the instances."
  type        = string
}

variable "subnet_self_links" {
  description = "A map of all available subnet names to their self_links."
  type        = map(string)
}

variable "admin_password" {
  description = "Admin password for FortiGate instances"
  type        = string
  sensitive   = true
  default     = "FortiGate123!"
}

variable "forwarding_rule_ips" {
  description = "A map of region to forwarding rule IP addresses"
  type        = map(string)
  default     = {}
}

variable "subnet_gateways" {
  description = "A map of subnet names to their gateway IP addresses"
  type        = map(string)
  default     = {}
}

variable "fortigate_version" {
  description = "FortiGate version extracted from boot disk image"
  type        = string
  default     = ""
}