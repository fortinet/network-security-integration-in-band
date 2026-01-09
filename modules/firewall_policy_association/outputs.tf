output "association_name" {
  description = "The name of the created firewall policy association"
  value       = google_compute_network_firewall_policy_association.default.name
}

output "association_id" {
  description = "The ID of the created firewall policy association"
  value       = google_compute_network_firewall_policy_association.default.id
}
