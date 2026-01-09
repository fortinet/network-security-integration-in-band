resource "google_network_security_intercept_deployment_group" "fgt" {
  provider                      = google-beta
  intercept_deployment_group_id = "${var.prefix}-${var.deployment_group_id}"
  location                      = "global"
  project                       = var.project_id
  network                       = var.network
}