output "templates_by_name" {
  description = "A map of the created instance templates, keyed by their short name."
  value = {
    for key, t in google_compute_instance_template.templates :
    # Use the short name from the input variable as the key, and the created
    # resource's self_link as the value. This allows the mig module to look
    # up the template using the short name from the .tfvars file.
    var.instance_templates[key].name => t.self_link
  }
}