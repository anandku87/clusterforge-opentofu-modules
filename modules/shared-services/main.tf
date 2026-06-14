resource "google_storage_bucket" "state_backend" {
  name          = var.state_bucket_name
  project       = var.project_id
  location      = var.region
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

resource "google_artifact_registry_repository" "docker_repo" {
  repository_id = var.artifact_registry_name
  location      = var.region
  project       = var.project_id

  format = "DOCKER"

  description = "Docker repository for ClusterForge container images"
}

resource "google_service_account" "clusterforge_platform" {
  account_id   = var.service_account_name
  display_name = "ClusterForge Platform Service Account"
  description  = "Service account for ClusterForge platform automation and orchestration"
  project      = var.project_id
}
