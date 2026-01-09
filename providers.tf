terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.50.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.50.0"
    }
  }
}

provider "google" {
  project = var.producer_project_id
}

provider "google-beta" {
  alias                   = "producer"
  project                 = var.producer_project_id
  billing_project         = var.producer_project_id
  user_project_override   = true
}

provider "google-beta" {
  alias                   = "consumer"
  project                 = var.consumer_project_id
  billing_project         = var.producer_project_id
  user_project_override   = true
}