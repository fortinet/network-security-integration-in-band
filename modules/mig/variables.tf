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
  description = "The name of the Managed Instance Group."
}

variable "region" {
  type        = string
  description = "The region for the MIG."
}

variable "distribution_zones" {
  type        = list(string)
  description = "The list of zones to distribute instances across."
}

variable "target_size" {
  type        = number
  description = "The number of instances to create and maintain."
}

variable "instance_template_self_link" {
  type        = string
  description = "The self_link of the instance template to use."
}