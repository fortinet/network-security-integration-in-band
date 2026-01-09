output "security_profile_name" {
  description = "The name of the created security profile"
  value       = google_network_security_security_profile.default.name
}

output "security_profile_id" {
  description = "The ID of the created security profile"
  value       = google_network_security_security_profile.default.name
}

output "security_profile_self_link" {
  description = "The self-link of the created security profile"
  value       = google_network_security_security_profile.default.id
}

output "security_profile_group_name" {
  description = "The name of the created security profile group"
  value       = google_network_security_security_profile_group.default.name
}

output "security_profile_group_id" {
  description = "The ID of the created security profile group"
  value       = google_network_security_security_profile_group.default.name
}

output "security_profile_group_full_id" {
  description = "The full ID of the created security profile group for firewall policy references"
  value       = google_network_security_security_profile_group.default.id
}
