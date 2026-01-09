variable "endpoint_group_id" {
  description = "The ID for the Intercept Endpoint Group (must be unique in the project)."
  type        = string
}

variable "project_id" {
  description = "The GCP project ID where the endpoint group will be created."
  type        = string
}

variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names."
}

variable "location" {
  description = "The location for the intercept endpoint group."
  type        = string
  default     = "global"
}

variable "intercept_deployment_group_id" {
  description = "The ID of the intercept deployment group to attach this endpoint group to."
  type        = string
}
