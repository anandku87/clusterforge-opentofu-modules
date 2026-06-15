variable "project_id" {
  description = "GCP project id for shared services resources"
  type        = string
}

variable "region" {
  description = "GCP region for regional resources"
  type        = string
}

variable "state_bucket_name" {
  description = "Name of the Cloud Storage bucket for OpenTofu remote state"
  type        = string
}

variable "artifact_registry_name" {
  description = "Name of the Artifact Registry repository"
  type        = string
}

variable "service_account_name" {
  description = "Name of the ClusterForge platform service account"
  type        = string
}
