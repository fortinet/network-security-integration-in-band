variable "deployment_group_id" {
  description = "The ID for the Intercept Deployment Group (must be unique in the project)."
  type        = string
}

variable "project_id" {
  description = "The GCP project ID where the deployment group will be created."
  type        = string
}

variable "network" {
  description = "The name or self-link of the network where the deployment group will be deployed."
  type        = string
}

variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names."
}