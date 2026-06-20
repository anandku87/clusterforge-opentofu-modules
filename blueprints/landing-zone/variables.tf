variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for all resources"
  type        = string
  default     = "us-central1"
}

variable "shared_vpc_name" {
  description = "Name of the shared services hub VPC"
  type        = string
  default     = "shared-services-vpc"
}

variable "shared_subnet_cidr" {
  description = "CIDR block for shared services subnet"
  type        = string
  default     = "10.10.0.0/24"
}

variable "dev_vpc_name" {
  description = "Name of the development spoke VPC"
  type        = string
  default     = "dev-vpc"
}

variable "dev_subnet_cidr" {
  description = "CIDR block for development subnet"
  type        = string
  default     = "10.20.0.0/24"
}

variable "prod_vpc_name" {
  description = "Name of the production spoke VPC"
  type        = string
  default     = "prod-vpc"
}

variable "prod_subnet_cidr" {
  description = "CIDR block for production subnet"
  type        = string
  default     = "10.30.0.0/24"
}

variable "sandbox_vpc_name" {
  description = "Name of the sandbox spoke VPC"
  type        = string
  default     = "sandbox-vpc"
}

variable "sandbox_subnet_cidr" {
  description = "CIDR block for sandbox subnet"
  type        = string
  default     = "10.40.0.0/24"
}
