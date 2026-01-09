variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names."
}

variable "project_id" {
  type        = string
  description = "The GCP project ID."
}

variable "name" {
  type        = string
  description = "The name of the forwarding rule."
}

variable "region" {
  type        = string
  description = "The region for the forwarding rule."
}

variable "backend_service_self_link" {
  type        = string
  description = "The self_link of the backend service to forward traffic to."
}

variable "network_self_link" {
  type        = string
  description = "The self_link of the network this forwarding rule belongs to."
}

variable "subnet_self_link" {
  type        = string
  description = "The self_link of the subnetwork this forwarding rule belongs to."
}

variable "ip_address" {
  type        = string
  description = "The static IP address to use for the forwarding rule."
  default     = null
}