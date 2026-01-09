variable "security_profile_id" {
  description = "The ID for the Security Profile (must be unique in the organization)."
  type        = string
}

variable "security_profile_group_id" {
  description = "The ID for the Security Profile Group (must be unique in the organization)."
  type        = string
}

variable "intercept_endpoint_group_id" {
  description = "The ID or name of the intercept endpoint group to associate with the custom intercept profile."
  type        = string
}

variable "organization_id" {
  description = "The GCP organization ID where the security profile will be created."
  type        = string
}

variable "project_id" {
  description = "The GCP project ID to use for billing/quota purposes."
  type        = string
}

variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names."
}

variable "location" {
  description = "The location for the security profile."
  type        = string
  default     = "global"
}
