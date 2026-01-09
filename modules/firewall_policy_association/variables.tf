variable "association_name" {
  description = "The name for the firewall policy association"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID where the association will be created"
  type        = string
}

variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names"
}

variable "firewall_policy_name" {
  description = "The name of the firewall policy to associate"
  type        = string
}

variable "network_self_link" {
  description = "The self-link of the VPC network to associate with the firewall policy"
  type        = string
}
