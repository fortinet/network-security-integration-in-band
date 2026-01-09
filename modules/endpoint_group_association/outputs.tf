output "association_name" {
  description = "The name of the created intercept endpoint group association"
  value       = google_network_security_intercept_endpoint_group_association.default.name
}

output "association_id" {
  description = "The ID of the created intercept endpoint group association"
  value       = google_network_security_intercept_endpoint_group_association.default.intercept_endpoint_group_association_id
}
