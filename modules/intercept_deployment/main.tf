resource "google_network_security_intercept_deployment" "id" {
      provider                  = google-beta
      intercept_deployment_id   = "${var.prefix}-${var.deployment_id}"
      location                  = var.location
      project                   = var.project_id
      forwarding_rule            = var.forwarding_rule
      intercept_deployment_group = var.intercept_deployment_group_id


}