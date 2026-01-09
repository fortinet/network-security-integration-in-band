output "ip_address" {
  description = "The internal IP address of the forwarding rule."
  value       = google_compute_forwarding_rule.default.ip_address
}

output "self_link" {
  description = "The self_link of the created forwarding rule."
  value = google_compute_forwarding_rule.default.self_link
}

output "region" {
  description = "The region of the forwarding rule."
  value = google_compute_forwarding_rule.default.region
}