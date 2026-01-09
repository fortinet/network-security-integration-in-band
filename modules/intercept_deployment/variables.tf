variable "deployment_id" {
  description = "The ID for the Intercept Deployment Group (must be unique in the project)."
  type        = string
}

variable "project_id" {
  description = "The GCP project ID where the deployment group will be created."
  type        = string
}

variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names."
}

variable "location" {
  description = "The location (region/zone) for the intercept deployment."
  type        = string
}

variable "intercept_deployment_group_id" {
  description = "The ID of the intercept deployment group to attach this deployment to."
  type        = string
}
variable "forwarding_rule" {
  description = "The self-link or ID of the forwarding rule for the ILB."
  type        = string
}