variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names."
}

variable "project_id" {
  type        = string
  description = "The GCP project ID."
}

variable "vpc_name" {
  type        = string
  description = "The name of the management VPC."
}

variable "firewall_ingress_name" {
  type        = string
  description = "The name of the ingress firewall rule for the management VPC."
}

variable "firewall_egress_name" {
  type        = string
  description = "The name of the egress firewall rule for the management VPC."
}

variable "subnets" {
  type = list(object({
    name   = string
    region = string
    cidr   = string
  }))
  description = "A list of subnets to create in the management VPC."
}