# Instance templates with bootstrap configuration
resource "google_compute_instance_template" "templates" {
  for_each = var.instance_templates

  project      = var.project_id
  name         = "${var.prefix}-${each.value.name}"
  region       = each.value.region
  machine_type = var.machine_type

  disk {
    source_image = var.boot_disk_image
    auto_delete  = true
    boot         = true
    disk_size_gb = 10
    disk_type    = "pd-balanced"
    mode         = "READ_WRITE"
  }

  # Data interface (port1)
  network_interface {
    subnetwork = var.subnet_self_links[each.value.data_subnet_name]
    access_config {
      // Ephemeral external IP for initial setup
    }
  }

  # Management interface (port2)
  network_interface {
    subnetwork = var.subnet_self_links[each.value.mgmt_subnet_name]
    access_config {
      // Ephemeral external IP for management access
    }
  }

  # Bootstrap configuration with FortiGate setup
  metadata = {
    # Enable serial console access for debugging
    serial-port-enable = "true"
    
    # FortiGate license type
    license_type = "payg"
    
    # Bootstrap configuration for NSI setup
    user-data = templatefile("${path.root}/bootstrap/bootstrap.conf", {
      hostname         = "${var.prefix}-${each.key}-${each.value.region}"
      alias           = "${var.prefix} NSI FortiGate"
      fortigate_version = var.fortigate_version
      admin_password   = var.admin_password
      producer_gateway = var.subnet_gateways[each.value.data_subnet_name]
      mgmt_gateway     = var.subnet_gateways[each.value.mgmt_subnet_name]
      frontend_ip      = var.forwarding_rule_ips[each.value.region]
    })
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  # Use default service account with exact scopes from working praveen-pi1 deployment
  service_account {
    email = "default"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  # Labels for resource organization
  labels = {
    environment = "nsi"
    role        = "security-appliance"
    region      = each.value.region
  }
}