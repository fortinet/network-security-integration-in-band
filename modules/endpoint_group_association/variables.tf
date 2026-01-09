variable "association_id" {
  description = "The ID for the Intercept Endpoint Group Association (must be unique in the project)."
  type        = string
}

variable "project_id" {
  description = "The GCP project ID where the association will be created."
  type        = string
}

variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names."
}

variable "location" {
  description = "The location for the intercept endpoint group association."
  type        = string
  default     = "global"
}

variable "intercept_endpoint_group_id" {
  description = "The ID or name of the intercept endpoint group to associate."
  type        = string
}

variable "network" {
  description = "The network to associate with the endpoint group. Can be a VPC network name or self-link."
  type        = string
}
