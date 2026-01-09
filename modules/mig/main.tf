resource "google_compute_region_instance_group_manager" "mig" {
  project = var.project_id
  name    = "${var.prefix}-${var.name}"
  region  = var.region

  # This sets the base name for the instances created by the MIG
  base_instance_name = "${var.prefix}-${var.name}"

  # This version block connects the MIG to the instance template
  version {
    name              = "primary"
    instance_template = var.instance_template_self_link
  }

  # This defines the zones for a regional MIG
  distribution_policy_zones = var.distribution_zones

  target_size = var.target_size
}