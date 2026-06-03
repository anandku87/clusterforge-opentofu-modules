output "service_account_email" {
  description = "Email address of the created Google Service Account."
  value       = google_service_account.gsa.email
}

output "service_account_name" {
  description = "Fully qualified resource name of the created Google Service Account."
  value       = google_service_account.gsa.name
}
