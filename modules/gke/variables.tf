variable "project_id" {
  description = "GCP project id where cluster will be created"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "GCP region (regional cluster location)"
  type        = string
}

variable "network" {
  description = "Existing VPC network name"
  type        = string
}

variable "subnetwork" {
  description = "Existing subnetwork name"
  type        = string
}

variable "pods_range_name" {
  description = "Name of the pods secondary range (IP aliases)"
  type        = string
}

variable "services_range_name" {
  description = "Name of the services secondary range (IP aliases)"
  type        = string
}

variable "machine_type" {
  description = "Machine type for node pool"
  type        = string
}

variable "node_count" {
  description = "Initial number of nodes in the node pool"
  type        = number
}

variable "min_nodes" {
  description = "Minimum nodes for autoscaling"
  type        = number
}

variable "max_nodes" {
  description = "Maximum nodes for autoscaling"
  type        = number
}

variable "disk_size" {
  description = "Boot disk size in GB for nodes"
  type        = number
}

variable "disk_type" {
  description = "Boot disk type for nodes (pd-standard or pd-ssd)"
  type        = string
  default     = "pd-standard"
}

variable "deletion_protection" {
  description = "Protect cluster from accidental deletion"
  type        = bool
  default     = false
}
