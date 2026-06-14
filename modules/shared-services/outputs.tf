output "state_bucket_name" {
  description = "Name of the Cloud Storage bucket for OpenTofu state"
  value       = google_storage_bucket.state_backend.name
}

output "state_bucket_url" {
  description = "URL of the Cloud Storage state backend bucket"
  value       = google_storage_bucket.state_backend.url
}

output "artifact_registry_name" {
  description = "Name of the Artifact Registry repository"
  value       = google_artifact_registry_repository.docker_repo.name
}

output "artifact_registry_repository_url" {
  description = "Repository URL for Docker images"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_repo.repository_id}"
}

output "service_account_email" {
  description = "Email address of the ClusterForge platform service account"
  value       = google_service_account.clusterforge_platform.email
}

output "service_account_id" {
  description = "Unique ID of the ClusterForge platform service account"
  value       = google_service_account.clusterforge_platform.unique_id
}
