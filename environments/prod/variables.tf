variable "project_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "node_count" {
  type = number
}

variable "min_nodes" {
  type = number
}

variable "max_nodes" {
  type = number
}

variable "disk_size" {
  type = number
}

variable "deletion_protection" {
  type = bool
}
