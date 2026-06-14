variable "project_id" {
  description = "GCP project id for resources"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "GCP region for regional resources"
  type        = string
}

variable "machine_type" {
  description = "Default machine type for node pools"
  type        = string
  default     = "e2-standard-4"
}

variable "node_count" {
  description = "Initial node count for primary node pool"
  type        = number
  default     = 1
}

variable "min_nodes" {
  description = "Minimum nodes for autoscaling"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Maximum nodes for autoscaling"
  type        = number
  default     = 3
}

variable "disk_size" {
  description = "Boot disk size in GB for nodes"
  type        = number
  default     = 100
}

variable "deletion_protection" {
  description = "Protect cluster from accidental deletion"
  type        = bool
  default     = false
}

variable "enable_argocd" {
  description = "Enable ArgoCD installation in this blueprint."
  type        = bool
  default     = true
}

variable "enable_istio" {
  description = "Enable Istio installation in this blueprint."
  type        = bool
  default     = true
}

variable "enable_cert_manager" {
  description = "Enable Cert Manager installation in this blueprint."
  type        = bool
  default     = true
}

variable "enable_metrics_server" {
  description = "Enable Metrics Server installation in this blueprint."
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "VPC name used by the blueprint/network module"
  type        = string
  default     = "clusterforge-vpc"
}

variable "subnet_name" {
  description = "Subnet name used by the blueprint/network module"
  type        = string
  default     = "clusterforge-subnet"
}

variable "subnet_cidr" {
  description = "Subnet CIDR used by the blueprint/network module"
  type        = string
  default     = "10.10.0.0/20"
}

variable "pods_cidr" {
  description = "Pods secondary CIDR"
  type        = string
  default     = "10.20.0.0/16"
}

variable "services_cidr" {
  description = "Services secondary CIDR"
  type        = string
  default     = "10.30.0.0/20"
}
