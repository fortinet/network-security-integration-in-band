output "firewall_policy_name" {
  description = "The name of the created network firewall policy"
  value       = google_compute_network_firewall_policy.default.name
}

output "firewall_policy_id" {
  description = "The ID of the created network firewall policy"
  value       = google_compute_network_firewall_policy.default.id
}

output "firewall_policy_self_link" {
  description = "The self-link of the created network firewall policy"
  value       = google_compute_network_firewall_policy.default.self_link
}

output "ingress_rule_id" {
  description = "The ID of the ingress firewall rule"
  value       = google_compute_network_firewall_policy_rule.ingress_rule.id
}

output "egress_rule_id" {
  description = "The ID of the egress firewall rule"
  value       = google_compute_network_firewall_policy_rule.egress_rule.id
}
