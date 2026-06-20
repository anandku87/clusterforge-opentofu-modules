variable "billing_account" {
  description = "The alphanumeric ID of the billing account to attach all projects to"
  type        = string
}

variable "folder_id" {
  description = "The numeric ID of the folder to create projects under. If not provided, projects are created at the organization root."
  type        = string
  default     = null
}

variable "shared_project_id" {
  description = "The project ID for the shared services hub project"
  type        = string
  default     = "clusterforge-shared"
}

variable "shared_project_name" {
  description = "The display name for the shared services hub project"
  type        = string
  default     = "ClusterForge Shared Services"
}

variable "dev_project_id" {
  description = "The project ID for the development spoke project"
  type        = string
  default     = "clusterforge-dev"
}

variable "dev_project_name" {
  description = "The display name for the development spoke project"
  type        = string
  default     = "ClusterForge Development"
}

variable "prod_project_id" {
  description = "The project ID for the production spoke project"
  type        = string
  default     = "clusterforge-prod"
}

variable "prod_project_name" {
  description = "The display name for the production spoke project"
  type        = string
  default     = "ClusterForge Production"
}

variable "sandbox_project_id" {
  description = "The project ID for the sandbox spoke project"
  type        = string
  default     = "clusterforge-sandbox"
}

variable "sandbox_project_name" {
  description = "The display name for the sandbox spoke project"
  type        = string
  default     = "ClusterForge Sandbox"
}

variable "additional_labels" {
  description = "Additional labels to apply to all projects"
  type        = map(string)
  default     = {}
}

variable "create_platform_service_accounts" {
  description = "Whether to create platform service accounts in all projects"
  type        = bool
  default     = false
}
