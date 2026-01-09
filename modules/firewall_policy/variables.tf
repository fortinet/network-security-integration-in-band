variable "firewall_policy_name" {
  description = "The name for the network firewall policy"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID where the firewall policy will be created"
  type        = string
}

variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names"
}

variable "security_profile_group_id" {
  description = "The full ID of the security profile group to apply"
  type        = string
}

variable "ingress_rule_priority" {
  description = "Priority for the ingress firewall rule"
  type        = number
  default     = 10
}

variable "egress_rule_priority" {
  description = "Priority for the egress firewall rule"
  type        = number
  default     = 11
}
