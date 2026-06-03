variable "project_id" {
  description = "GCP project ID where the service account and IAM bindings are created."
  type        = string
}

variable "service_account_name" {
  description = "Short name for the Google Service Account."
  type        = string
}

variable "service_account_display_name" {
  description = "Display name for the Google Service Account."
  type        = string
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for the target service account."
  type        = string
}

variable "kubernetes_service_account" {
  description = "Kubernetes service account name to bind to the Google Service Account."
  type        = string
}

variable "roles" {
  description = "List of IAM roles to assign to the Google Service Account."
  type        = list(string)
}
