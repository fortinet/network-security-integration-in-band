output "endpoint_group_name" {
  description = "The name of the created intercept endpoint group"
  value       = google_network_security_intercept_endpoint_group.default.name
}

output "endpoint_group_id" {
  description = "The ID of the created intercept endpoint group"
  value       = google_network_security_intercept_endpoint_group.default.intercept_endpoint_group_id
}
