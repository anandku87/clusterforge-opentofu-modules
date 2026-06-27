# Merge default labels with additional labels
locals {
  default_labels = {
    platform    = "clusterforge"
    managed_by  = "opentofu"
    environment = var.environment
  }

  merged_labels = merge(local.default_labels, var.additional_labels)
}

# Create the GCP project
resource "google_project" "main" {
  project_id          = var.project_id
  name                = var.project_name
  billing_account     = var.billing_account
  folder_id           = var.folder_id
  labels              = local.merged_labels
  auto_create_network = false

  # Prevent accidental destruction
  lifecycle {
    prevent_destroy = true
  }
}

# Enable required Google Cloud services
resource "google_project_service" "services" {
  for_each = toset(var.enabled_services)

  project = google_project.main.project_id
  service = each.value

  # Disable the service if it is removed from the list
  disable_on_destroy = false
}

# Create platform service account (optional)
resource "google_service_account" "platform" {
  count = var.create_platform_service_account ? 1 : 0

  project      = google_project.main.project_id
  account_id   = "clusterforge-platform"
  display_name = "ClusterForge Platform Service Account"
  description  = "Service account for ClusterForge platform operations"
}
