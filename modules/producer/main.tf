# Create a single VPC network
resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = "${var.prefix}-${var.vpc_name}"
  auto_create_subnetworks = false
}

# Create subnets for the single VPC (this still uses for_each on the subnets list)
resource "google_compute_subnetwork" "subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  project                  = var.project_id
  name                     = "${var.prefix}-${each.value.name}"
  ip_cidr_range            = each.value.cidr
  region                   = each.value.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# Create a single ingress firewall rule
resource "google_compute_firewall" "allow_all_ingress" {
  project       = var.project_id
  name          = "${var.prefix}-${var.firewall_ingress_name}"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }
}

# Create a single egress firewall rule
resource "google_compute_firewall" "allow_all_egress" {
  project            = var.project_id
  name               = "${var.prefix}-${var.firewall_egress_name}"
  network            = google_compute_network.vpc.name
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }
}