variable "prefix" {
  type        = string
  description = "A standard prefix for all resource names."
  default     = "demofgt-nsi"
}

variable "producer_project_id" {
  type        = string
  description = "The GCP project ID to deploy the producer resources in."
  default     = "praveen-pi2"
}

variable "consumer_project_id" {
  type        = string
  description = "The GCP project ID for consumer VPC and related resources. If not specified, defaults to main producer_project_id."
  default     = ""
}

variable "instance_templates" {
  description = "A map of instance templates to create."
  type = map(object({
    name             = string
    region           = string
    data_subnet_name = string
    mgmt_subnet_name = string
  }))
  default = {
    "west-template" = {
      name             = "763-v5"
      region           = "us-west1"
      data_subnet_name = "west"
      mgmt_subnet_name = "mgmt-west"
    },
    "central-template" = {
      name             = "763-v5-central1"
      region           = "us-central1"
      data_subnet_name = "central"
      mgmt_subnet_name = "central-mgmt"
    }
  }
}

variable "machine_type" {
  description = "The machine type for the instances in the template."
  type        = string
  default     = "n1-standard-4"
}

variable "boot_disk_image" {
  description = "The boot disk image for the instances."
  type        = string
  default     = "projects/fortigcp-project-001/global/images/fortinet-fgtondemand-763-20250423-001-w-license"
}

variable "fortigate_version" {
  description = "FortiOS version (e.g., 7.6.2, 7.4.1, etc.)"
  type        = string
  default     = "7.6.3"
}

variable "admin_password" {
  description = "Admin password for FortiGate instances"
  type        = string
  sensitive   = true
  default     = "FortiGate123!"
}

variable "producer_vpc_name" {
  type        = string
  description = "Name for the single producer VPC."
  default     = "ib-new"
}

variable "producer_subnets" {
  type = list(object({
    name   = string
    region = string
    cidr   = string
  }))
  description = "List of subnets for the single producer VPC."
  default = [
    { name = "central", region = "us-central1", cidr = "10.50.150.0/24" },
    { name = "east",    region = "us-east1",    cidr = "10.50.155.0/24" },
    { name = "west",    region = "us-west1",    cidr = "10.50.160.0/24" }
  ]
}

variable "producer_firewall_ingress_name" {
  type    = string
  default = "allow-all-in"
}

variable "producer_firewall_egress_name" {
  type    = string
  default = "allow-all-egr"
}

variable "mgmt_vpc_name" {
  type    = string
  default = "ib-new-mgmt"
}
variable "mgmt_subnets" {
  type = list(object({
    name   = string
    region = string
    cidr   = string
  }))
  default = [
    { name = "central-mgmt", region = "us-central1", cidr = "10.50.170.0/24" },
    { name = "mgmt-east",    region = "us-east1",    cidr = "10.50.175.0/24" },
    { name = "mgmt-west",    region = "us-west1",    cidr = "10.50.180.0/24" }
  ]
}
variable "mgmt_firewall_ingress_name" {
  type    = string
  default = "allow-all-ing1"
}
variable "mgmt_firewall_egress_name" {
  type    = string
  default = "allow-all-egr1"
}


variable "consumer_vpcs" {
  type = map(object({
    name                  = string
    firewall_ingress_name = string
    firewall_egress_name  = string
    subnets = list(object({
      name   = string
      region = string
      cidr   = string
    }))
  }))
  description = "A map of VPC configurations for the consumer environment."
  default = {
    "spoke1" = {
      name                  = "ib-new-spoke1"
      firewall_ingress_name = "spoke1-allow-all-ing"
      firewall_egress_name  = "spoke1-allow-all-egr"
      subnets = [
        { name = "spoke1-central1", region = "us-central1", cidr = "10.10.0.0/24" },
        { name = "spoke1-east1",    region = "us-east1",    cidr = "10.11.0.0/24" },
        { name = "spoke1-west",     region = "us-west1",    cidr = "10.12.0.0/24" }
      ]
    }
  }
}

variable "managed_instance_groups" {
  description = "A map of Managed Instance Groups to create."
  type = map(object({
    name          = string
    region        = string
    zones         = list(string)
    size          = number
    template_name = string
  }))
  default = {
    "west-mig" = {
      name          = "us-west1-multi-ig"
      region        = "us-west1"
      zones         = ["us-west1-a", "us-west1-b", "us-west1-c"]
      size          = 3
      template_name = "763-v5"
    },
    "central-mig" = {
      name          = "us-central1-multi-ig"
      region        = "us-central1"
      zones         = ["us-central1-a", "us-central1-b"]
      size          = 2
      template_name = "763-v5-central1"
    }
  }
}

variable "backend_services" {
  description = "A map of regional backend services to create."
  type = map(object({
    name     = string
    region   = string
    mig_keys = list(string)
  }))
  default = {
    "west-bks" = {
      name     = "us-west1-bks"
      region   = "us-west1"
      mig_keys = ["west-mig"]
    },
    "central-bks" = {
      name     = "us-central1-bks"
      region   = "us-central1"
      mig_keys = ["central-mig"]
    }
  }
}

variable "forwarding_rules" {
  description = "A map of internal forwarding rules to create."
  type = map(object({
    name                = string
    region              = string
    backend_service_key = string
    subnet_key          = string
  }))
  default = {
    "west-fwd" = {
      name                = "us-west1-fwd"
      region              = "us-west1"
      backend_service_key = "west-bks"
      subnet_key          = "west"
    },
    "central-fwd" = {
      name                = "us-central1-fwd"
      region              = "us-central1"
      backend_service_key = "central-bks"
      subnet_key          = "central"
    }
  }
}

variable "dg_name" {
  type    = string
  default = "ftnt-dg"
}

variable "epg_name" {
  type        = string
  description = "The name for the intercept endpoint group"
  default     = "ftnt-epg"
}

variable "epg_association_name" {
  type        = string
  description = "The name for the intercept endpoint group association"
  default     = "ftnt-epg-assoc"
}

variable "security_profile_name" {
  type        = string
  description = "The name for the security profile"
  default     = "ftnt-sp1"
}

variable "security_profile_group_name" {
  type        = string
  description = "The name for the security profile group"
  default     = "ftnt-spg1"
}

variable "organization_id" {
  type        = string
  description = "The GCP organization ID"
  default     = "769491663990"
}

variable "firewall_policy_name" {
  type        = string
  description = "The name for the network firewall policy"
  default     = "nsi-fw-policy"
}

variable "firewall_policy_association_name" {
  type        = string
  description = "The name for the firewall policy association"
  default     = "policy-assoc"
}