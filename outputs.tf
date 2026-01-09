# --- Project Configuration Outputs ---
output "producer_project_id" {
  description = "The GCP project ID used for producer resources"
  value       = var.producer_project_id
}

output "consumer_project_id" {
  description = "The GCP project ID used for consumer VPC resources"
  value       = var.consumer_project_id != "" ? var.consumer_project_id : var.producer_project_id
}

# --- Intercept Deployment Outputs ---
output "intercept_deployment_group_name" {
  description = "The name of the intercept deployment group"
  value       = module.intercept_deployment_group.deployment_group_name
}

output "intercept_endpoint_group_name" {
  description = "The name of the intercept endpoint group"
  value       = module.intercept_endpoint_group.endpoint_group_name
}

output "intercept_endpoint_group_id" {
  description = "The ID of the intercept endpoint group"
  value       = module.intercept_endpoint_group.endpoint_group_id
}

output "intercept_endpoint_group_associations" {
  description = "Map of intercept endpoint group associations by consumer VPC"
  value = {
    for k, assoc in module.intercept_endpoint_group_association : k => {
      association_name = assoc.association_name
      association_id   = assoc.association_id
      vpc_name         = module.consumer.vpcs_by_name[k].name
    }
  }
}

output "intercept_deployments" {
  description = "Map of intercept deployment names by forwarding rule key"
  value = {
    for k, deployment in module.intercept_deployment : k => deployment.deployment_name
  }
}

output "intercept_deployment_details" {
  description = "Detailed information about each intercept deployment"
  value = {
    for k, deployment in module.intercept_deployment : k => {
      deployment_name = deployment.deployment_name
      forwarding_rule = local.fr_map[k].self_link
      location        = local.fr_map[k].zone
      region          = local.fr_map[k].region
    }
  }
}

output "security_profile_name" {
  description = "The name of the security profile"
  value       = module.security_profile.security_profile_name
}

output "security_profile_self_link" {
  description = "The self-link of the security profile"
  value       = module.security_profile.security_profile_self_link
}

output "security_profile_group_name" {
  description = "The name of the security profile group"
  value       = module.security_profile.security_profile_group_name
}

output "firewall_policy_name" {
  description = "The name of the network firewall policy"
  value       = module.firewall_policy.firewall_policy_name
}

output "firewall_policy_self_link" {
  description = "The self-link of the network firewall policy"
  value       = module.firewall_policy.firewall_policy_self_link
}

output "firewall_policy_associations" {
  description = "Map of firewall policy associations by consumer VPC"
  value = {
    for k, assoc in module.firewall_policy_association : k => {
      association_name = assoc.association_name
      association_id   = assoc.association_id
      vpc_name         = module.consumer.vpcs_by_name[k].name
    }
  }
}

output "forwarding_rule_ips" {
  description = "Frontend IP addresses of the forwarding rules by region"
  value = {
    "us-west1"    = module.forwarding_rule["west-fwd"].ip_address
    "us-central1" = module.forwarding_rule["central-fwd"].ip_address
  }
  depends_on = [module.forwarding_rule]
}

output "fortigate_version" {
  description = "FortiOS version specified by user"
  value       = var.fortigate_version
}

output "fortigate_image_info" {
  description = "FortiGate boot disk image and specified version"
  value = {
    boot_disk_image     = var.boot_disk_image
    fortigate_version  = var.fortigate_version
  }
}
