# Get the default compute service account (for reference, but not used explicitly)
data "google_compute_default_service_account" "default" {}

# --- VPC Modules ---
module "producer" {
  source                     = "./modules/producer"
  prefix                     = var.prefix
  project_id                 = var.producer_project_id
  vpc_name                   = var.producer_vpc_name
  subnets                    = var.producer_subnets
  firewall_ingress_name      = var.producer_firewall_ingress_name
  firewall_egress_name       = var.producer_firewall_egress_name
}

module "mgmt" {
  source                     = "./modules/mgmt"
  prefix                     = var.prefix
  project_id                 = var.producer_project_id
  vpc_name                   = var.mgmt_vpc_name
  subnets                    = var.mgmt_subnets
  firewall_ingress_name      = var.mgmt_firewall_ingress_name
  firewall_egress_name       = var.mgmt_firewall_egress_name
}

module "consumer" {
  source        = "./modules/consumer"
  prefix        = var.prefix
  project_id    = var.consumer_project_id
  consumer_vpcs = var.consumer_vpcs
}

# --- Compute Modules ---
# Calculate third-to-last usable IP for each producer subnet
locals {
  subnet_last_ips = {
    for subnet in var.producer_subnets : 
    subnet.name => cidrhost(subnet.cidr, -4)  # -4 gives the third-to-last usable IP
  }
}

# Static IP addresses for load balancer frontends - using last usable IP in subnet
resource "google_compute_address" "lb_frontend_ips" {
  for_each = var.forwarding_rules
  
  name         = "${var.prefix}-${each.value.region}-frontend-ip"
  region       = each.value.region
  project      = var.producer_project_id
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  
  # Use the producer subnet for each region using the subnet key from forwarding rule
  subnetwork = module.producer.subnets_by_name[each.value.subnet_key]
  
  # Set to last usable IP in the subnet
  address = local.subnet_last_ips[each.value.subnet_key]
}

# Instance templates with static frontend IPs
module "instance_template" {
  source            = "./modules/instance_template"
  prefix            = var.prefix
  project_id        = var.producer_project_id
  instance_templates = var.instance_templates
  machine_type      = var.machine_type
  boot_disk_image   = var.boot_disk_image
  admin_password    = var.admin_password
  fortigate_version = var.fortigate_version
  
  # Use the static IP addresses dynamically mapped by region
  forwarding_rule_ips = {
    for k, v in var.forwarding_rules : v.region => google_compute_address.lb_frontend_ips[k].address
  }

  subnet_self_links = merge(
    module.producer.subnets_by_name,
    module.mgmt.subnets_by_name
  )

  subnet_gateways = merge(
    module.producer.subnet_gateways,
    module.mgmt.subnet_gateways
  )
}

module "mig" {
  for_each = var.managed_instance_groups

  source             = "./modules/mig"
  prefix             = var.prefix
  project_id         = var.producer_project_id
  name               = each.value.name
  region             = each.value.region
  target_size        = each.value.size
  distribution_zones = each.value.zones

  # Use the instance template without dependency on forwarding rules
  instance_template_self_link = module.instance_template.templates_by_name[each.value.template_name]
}


# --- Load Balancing Modules ---
module "backend_service" {
  for_each = var.backend_services

  source     = "./modules/backend_service"
  prefix     = var.prefix
  project_id = var.producer_project_id
  name       = each.value.name
  region     = each.value.region

  backends = [
    for mig_key in each.value.mig_keys : {
      group = module.mig[mig_key].mig_self_links
    }
  ]
}

module "forwarding_rule" {
  for_each = var.forwarding_rules

  source                    = "./modules/forwarding_rule"
  prefix                    = var.prefix
  project_id                = var.producer_project_id
  name                      = each.value.name
  region                    = each.value.region
  backend_service_self_link = module.backend_service[each.value.backend_service_key].self_link
  network_self_link         = module.producer.vpc_self_link
  subnet_self_link          = module.producer.subnets_by_name[each.value.subnet_key]
  ip_address                = google_compute_address.lb_frontend_ips[each.key].address
}

# --- Intercept Deployment Group Module ---
module "intercept_deployment_group" {
  source              = "./modules/intercept_deployment_group"
  prefix              = var.prefix
  project_id          = var.producer_project_id
  deployment_group_id = var.dg_name
  network             = "projects/${var.producer_project_id}/global/networks/${module.producer.vpc_name}"

  providers = {
    google-beta = google-beta.producer
  }
}

# --- Intercept Endpoint Group Module ---
module "intercept_endpoint_group" {
  source                        = "./modules/endpoint_group"
  prefix                        = var.prefix
  project_id                    = var.consumer_project_id
  endpoint_group_id             = var.epg_name
  location                      = "global"
  intercept_deployment_group_id = module.intercept_deployment_group.deployment_group_name
  
  providers = {
    google-beta = google-beta.consumer
  }
}

# --- Intercept Endpoint Group Association Module ---
module "intercept_endpoint_group_association" {
  source = "./modules/endpoint_group_association"
  
  for_each = module.consumer.vpcs_by_name

  prefix                      = var.prefix
  project_id                  = var.consumer_project_id
  association_id              = "${var.epg_association_name}-${each.key}"
  location                    = "global"
  intercept_endpoint_group_id = module.intercept_endpoint_group.endpoint_group_name
  network                     = "projects/${var.consumer_project_id}/global/networks/${each.value.name}"
  
  providers = {
    google-beta = google-beta.consumer
  }
}

# --- Security Profile and Group Module ---
module "security_profile" {
  source                        = "./modules/SecurityProfileandGroup"
  prefix                        = var.prefix
  project_id                    = var.consumer_project_id
  security_profile_id           = var.security_profile_name
  security_profile_group_id     = var.security_profile_group_name
  organization_id               = var.organization_id
  intercept_endpoint_group_id   = module.intercept_endpoint_group.endpoint_group_name
  location                      = "global"
  
  providers = {
    google-beta = google-beta.consumer
  }
}

# --- Firewall Policy Module ---
module "firewall_policy" {
  source                      = "./modules/firewall_policy"
  prefix                      = var.prefix
  project_id                  = var.consumer_project_id
  firewall_policy_name        = var.firewall_policy_name
  security_profile_group_id   = module.security_profile.security_profile_group_full_id
  ingress_rule_priority       = 10
  egress_rule_priority        = 11
  
  providers = {
    google-beta = google-beta.consumer
  }
}

# --- Firewall Policy Association Module ---
module "firewall_policy_association" {
  source = "./modules/firewall_policy_association"
  
  for_each = module.consumer.vpcs_by_name

  prefix                = var.prefix
  project_id            = var.consumer_project_id
  association_name      = "${var.firewall_policy_association_name}-${each.key}"
  firewall_policy_name  = module.firewall_policy.firewall_policy_name
  network_self_link     = each.value.self_link
  
  providers = {
    google-beta = google-beta.consumer
  }
}

locals {
  fr_map = {
    for k, m in module.forwarding_rule :
    k => {
      self_link = m.self_link
      region    = var.forwarding_rules[k].region
      # Get the first zone from the corresponding MIG for this forwarding rule
      zone      = var.managed_instance_groups[var.backend_services[var.forwarding_rules[k].backend_service_key].mig_keys[0]].zones[0]
    }
  }
}

module "intercept_deployment" {
  source = "./modules/intercept_deployment"

  # Drive the loop from the composite map we just built
  for_each = local.fr_map

  prefix        = var.prefix
  # make the ID unique per FR (use key or name)
  deployment_id = "fgt-nsi-${each.key}"
  project_id = var.producer_project_id
  # Use zone location for intercept deployments
  location = each.value.zone

  forwarding_rule               = each.value.self_link
  intercept_deployment_group_id = module.intercept_deployment_group.deployment_group_name
  
  providers = {
    google-beta = google-beta.producer
  }
}

# --- Windows Test VM ---
resource "google_compute_instance" "windows_test_vm" {
  name         = "${var.prefix}-windows-test-central"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  project      = var.consumer_project_id

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2022"
      size  = 50
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = module.consumer.subnets_by_name["spoke1-central1"]
    
    access_config {
      # Ephemeral public IP for RDP access
    }
  }

  metadata = {
    windows-startup-script-ps1 = <<-EOT
      # Set timezone
      Set-TimeZone -Id "Pacific Standard Time"
      
      # Enable ping
      New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Enabled True -Direction Inbound
      
      # Install Chrome for web testing
      $ChromeInstaller = "$env:TEMP\chrome_installer.exe"
      Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $ChromeInstaller
      Start-Process -FilePath $ChromeInstaller -Args "/silent /install" -Wait
      Remove-Item $ChromeInstaller
    EOT
  }

  tags = ["windows-test", "spoke1"]

  labels = {
    environment = "test"
    purpose     = "app-control-testing"
  }
}

output "windows_vm_details" {
  description = "Details for accessing the Windows test VM"
  value = {
    name       = google_compute_instance.windows_test_vm.name
    zone       = google_compute_instance.windows_test_vm.zone
    internal_ip = google_compute_instance.windows_test_vm.network_interface[0].network_ip
    external_ip = try(google_compute_instance.windows_test_vm.network_interface[0].access_config[0].nat_ip, "No external IP")
  }
}
