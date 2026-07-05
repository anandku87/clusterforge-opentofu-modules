variable "shared_project_id" {
  description = "Shared services project ID"
  type        = string
}

variable "dev_project_id" {
  description = "Development project ID"
  type        = string
}

variable "prod_project_id" {
  description = "Production project ID"
  type        = string
}

variable "sandbox_project_id" {
  description = "Sandbox project ID"
  type        = string
}

variable "region" {
  description = "GCP region for the landing zone resources"
  type        = string
  default     = "asia-south1"
}
