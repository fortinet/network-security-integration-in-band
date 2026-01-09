output "mig_self_links" {
  description = "The self_link of the instance group created by the manager."
  value       = google_compute_region_instance_group_manager.mig.instance_group
}