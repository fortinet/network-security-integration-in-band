resource "google_compute_forwarding_rule" "default" {
  project = var.project_id
  name    = "${var.prefix}-${var.name}"
  region  = var.region

  load_balancing_scheme = "INTERNAL"

  backend_service = var.backend_service_self_link
  network         = var.network_self_link
  subnetwork      = var.subnet_self_link

  # Use the static IP address if provided
  ip_address = var.ip_address

  # Hardcoded to port 6081 as requested
  ports       = ["6081"]
  ip_protocol = "UDP"
}