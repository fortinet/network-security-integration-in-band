output "vpcs_by_name" {
  description = "A map of the created VPCs, keyed by their logical name (e.g., 'spoke1')."
  value = {
    for key, vpc in google_compute_network.vpcs :
    key => {
      name      = vpc.name
      self_link = vpc.self_link
    }
  }
}

output "subnets_by_name" {
  description = "A map of the created subnets, keyed by their short name (e.g., 'spoke1-central1')."
  value = {
    for subnet in google_compute_subnetwork.subnets :
    # CORRECTED: Use trimprefix to correctly get the short name for the map key.
    trimprefix(subnet.name, "${var.prefix}-") => subnet.self_link
  }
}