variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names."
}

variable "project_id" {
  type        = string
  description = "The GCP project ID."
}

variable "consumer_vpcs" {
  type = map(object({
    name                  = string
    firewall_ingress_name = string
    firewall_egress_name  = string
    subnets = list(object({
      name   = string
      region = string
      cidr   = string
    }))
  }))
  description = "A map of VPC configurations for the consumer environment."
}