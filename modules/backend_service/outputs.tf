output "self_link" {
  description = "The self_link of the created backend service."
  value       = google_compute_region_backend_service.default.self_link
}