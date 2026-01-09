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
  description = "The name of the backend service."
}

variable "region" {
  type        = string
  description = "The region for the backend service."
}

variable "backends" {
  type = list(object({
    group = string
  }))
  description = "List of Managed Instance Group self-links to use as backends."
  default     = []
}