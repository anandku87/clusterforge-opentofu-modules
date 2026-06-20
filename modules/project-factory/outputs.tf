output "project_id" {
  description = "The GCP project ID"
  value       = google_project.main.project_id
}

output "project_number" {
  description = "The GCP project number"
  value       = google_project.main.number
}

output "project_name" {
  description = "The display name of the GCP project"
  value       = google_project.main.name
}

output "billing_account" {
  description = "The billing account associated with the project"
  value       = google_project.main.billing_account
}

output "enabled_services" {
  description = "List of Google Cloud services that have been enabled"
  value       = var.enabled_services
}

output "service_account_email" {
  description = "Email address of the platform service account (if created)"
  value       = var.create_platform_service_account ? google_service_account.platform[0].email : null
}

output "service_account_id" {
  description = "Unique ID of the platform service account (if created)"
  value       = var.create_platform_service_account ? google_service_account.platform[0].unique_id : null
}

output "project_labels" {
  description = "Labels applied to the project"
  value       = google_project.main.labels
}

output "folder_id" {
  description = "The folder ID where the project is located"
  value       = google_project.main.folder_id
}
