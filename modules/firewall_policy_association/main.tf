resource "google_compute_network_firewall_policy_association" "default" {
  provider          = google-beta
  name              = "${var.prefix}-${var.association_name}"
  firewall_policy   = var.firewall_policy_name
  attachment_target = var.network_self_link
  project           = var.project_id
}
