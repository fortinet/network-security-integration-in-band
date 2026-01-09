# This locals block creates a flattened map of all subnets from all VPCs
# defined in the consumer_vpcs variable. This is necessary to create all
# subnets with a single resource block using for_each.
locals {
  all_subnets = merge(flatten([
    for vpc_key, vpc_config in var.consumer_vpcs : [
      for subnet_config in vpc_config.subnets : {
        # Create a unique key for each subnet, e.g., "spoke1-spoke1-central1"
        "${vpc_key}-${subnet_config.name}" = {
          name        = "${var.prefix}-${subnet_config.name}"
          cidr        = subnet_config.cidr
          region      = subnet_config.region
          # Link the subnet back to the VPC it belongs to
          network_id  = google_compute_network.vpcs[vpc_key].id
        }
      }
    ]
  ])...)
}

# Create all consumer VPC networks by looping over the 'consumer_vpcs' variable map
resource "google_compute_network" "vpcs" {
  for_each = var.consumer_vpcs

  project                 = var.project_id
  name                    = "${var.prefix}-${each.value.name}"
  auto_create_subnetworks = false
}

# Create all subnets by looping over the flattened map from the locals block
resource "google_compute_subnetwork" "subnets" {
  for_each = local.all_subnets

  project                  = var.project_id
  name                     = each.value.name
  ip_cidr_range            = each.value.cidr
  region                   = each.value.region
  network                  = each.value.network_id
  private_ip_google_access = true
}

# Create an ingress firewall rule for each VPC
resource "google_compute_firewall" "allow_all_ingress" {
  for_each = var.consumer_vpcs

  project       = var.project_id
  name          = "${var.prefix}-${each.value.firewall_ingress_name}"
  network       = google_compute_network.vpcs[each.key].name
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }
}

# Create an egress firewall rule for each VPC
resource "google_compute_firewall" "allow_all_egress" {
  for_each = var.consumer_vpcs

  project            = var.project_id
  name               = "${var.prefix}-${each.value.firewall_egress_name}"
  network            = google_compute_network.vpcs[each.key].name
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }
}