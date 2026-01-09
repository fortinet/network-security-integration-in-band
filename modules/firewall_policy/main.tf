resource "google_compute_network_firewall_policy" "default" {
  provider    = google-beta
  name        = "${var.prefix}-${var.firewall_policy_name}"
  project     = var.project_id
  description = "Network firewall policy for NSI inband security profile group"
}

resource "google_compute_network_firewall_policy_rule" "ingress_rule" {
  provider        = google-beta
  firewall_policy = google_compute_network_firewall_policy.default.name
  project         = var.project_id
  priority        = var.ingress_rule_priority
  action          = "apply_security_profile_group"
  direction       = "INGRESS"
  description     = "Ingress rule to apply security profile group"
  enable_logging  = true
  
  match {
    layer4_configs {
      ip_protocol = "all"
    }
    src_ip_ranges  = ["0.0.0.0/0"]
    dest_ip_ranges = ["0.0.0.0/0"]
  }
  
  security_profile_group = var.security_profile_group_id
}

resource "google_compute_network_firewall_policy_rule" "egress_rule" {
  provider        = google-beta
  firewall_policy = google_compute_network_firewall_policy.default.name
  project         = var.project_id
  priority        = var.egress_rule_priority
  action          = "apply_security_profile_group"
  direction       = "EGRESS"
  description     = "Egress rule to apply security profile group"
  enable_logging  = true
  
  match {
    layer4_configs {
      ip_protocol = "all"
    }
    src_ip_ranges  = ["0.0.0.0/0"]
    dest_ip_ranges = ["0.0.0.0/0"]
  }
  
  security_profile_group = var.security_profile_group_id
}
