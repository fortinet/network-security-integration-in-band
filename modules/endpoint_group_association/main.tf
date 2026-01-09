resource "google_network_security_intercept_endpoint_group_association" "default" {
  provider                                    = google-beta
  intercept_endpoint_group_association_id     = "${var.prefix}-${var.association_id}"
  intercept_endpoint_group                    = var.intercept_endpoint_group_id
  network                                     = var.network
  project                                     = var.project_id
  location                                    = var.location
}
