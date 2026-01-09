output "vpc_self_link" {
  description = "The self_link of the management VPC."
  value       = google_compute_network.vpc.self_link
}

output "vpc_name" {
  description = "The full name of the management VPC, including the prefix."
  value       = google_compute_network.vpc.name
}

output "subnets_by_name" {
  description = "A map of the created subnets, keyed by their short name."
  value = {
    for key, subnet in google_compute_subnetwork.subnets :
    key => subnet.self_link
  }
}

output "subnet_gateways" {
  description = "A map of subnet names to their gateway IP addresses."
  value = {
    for key, subnet in google_compute_subnetwork.subnets :
    key => subnet.gateway_address
  }
}