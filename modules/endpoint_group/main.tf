resource "google_network_security_intercept_endpoint_group" "default" {
  provider                      = google-beta
  intercept_endpoint_group_id   = "${var.prefix}-${var.endpoint_group_id}"
  intercept_deployment_group    = var.intercept_deployment_group_id
  project                       = var.project_id
  location                      = var.location
}
