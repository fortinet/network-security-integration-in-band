resource "google_network_security_security_profile" "default" {
  provider    = google-beta
  name        = "${var.prefix}-${var.security_profile_id}"
  type        = "CUSTOM_INTERCEPT"
  parent      = "organizations/${var.organization_id}"
  location    = var.location
  
  custom_intercept_profile {
    intercept_endpoint_group = var.intercept_endpoint_group_id
  }
}

resource "google_network_security_security_profile_group" "default" {
  provider                      = google-beta
  name                         = "${var.prefix}-${var.security_profile_group_id}"
  parent                       = "organizations/${var.organization_id}"
  location                     = var.location
  custom_intercept_profile     = google_network_security_security_profile.default.id
  
  depends_on = [google_network_security_security_profile.default]
}
