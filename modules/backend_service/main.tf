# Health check exists but not used to prevent instance cycling
resource "google_compute_region_health_check" "default" {
  project = var.project_id
  name    = "${var.prefix}-${var.name}-hc"
  region  = var.region
  
  check_interval_sec  = 5
  timeout_sec         = 3
  healthy_threshold   = 2
  unhealthy_threshold = 2
  
  http_health_check {
    port         = "8008"
    request_path = "/"
  }
}

resource "google_compute_region_backend_service" "default" {
  project = var.project_id
  name    = "${var.prefix}-${var.name}"
  region  = var.region

  load_balancing_scheme = "INTERNAL"
  protocol              = "UDP"
  health_checks         = [google_compute_region_health_check.default.id]

  # Dynamically add all the MIGs passed into the module
  dynamic "backend" {
    for_each = var.backends
    content {
      group          = backend.value.group
      balancing_mode = "CONNECTION"
    }
  }
}