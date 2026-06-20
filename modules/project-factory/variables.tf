variable "project_id" {
  description = "The unique project ID. Must be 6-30 lowercase letters, digits, or hyphens. Must start with a letter."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Project ID must be 6-30 characters, start with a letter, contain only lowercase letters, digits, and hyphens, and end with a letter or digit."
  }
}

variable "project_name" {
  description = "The display name of the project"
  type        = string
}

variable "billing_account" {
  description = "The alphanumeric ID of the billing account this project belongs to. The user or service account performing this operation with this module must have the Billing Project Manager or Billing Account Administrator role."
  type        = string
}

variable "folder_id" {
  description = "The numeric ID of the folder this project should be created under. If not supplied, the project is created under the organization."
  type        = string
  default     = null
}

variable "environment" {
  description = "The environment label for the project (e.g., dev, prod, sandbox, shared)"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["development", "production", "sandbox", "shared", "dev", "prod"], var.environment)
    error_message = "Environment must be one of: development, production, sandbox, shared, dev, or prod."
  }
}

variable "additional_labels" {
  description = "Additional labels to apply to the project. These are merged with default labels."
  type        = map(string)
  default     = {}
}

variable "enabled_services" {
  description = "List of Google Cloud services to enable. Default includes essential ClusterForge services."
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com"
  ]
}

variable "create_platform_service_account" {
  description = "Whether to create the clusterforge-platform service account"
  type        = bool
  default     = false
}
