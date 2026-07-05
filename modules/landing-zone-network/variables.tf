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
  description = "GCP region for all resources"
  type        = string
  default     = "us-central1"
}

# Hub VPC Configuration
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

variable "shared_pods_secondary_range_name" {
  description = "Secondary range name for shared services pods"
  type        = string
  default     = "shared-pods"
}

variable "shared_pods_secondary_range_cidr" {
  description = "CIDR block for shared services pods secondary range"
  type        = string
  default     = "10.11.0.0/16"
}

variable "shared_services_secondary_range_name" {
  description = "Secondary range name for shared services services"
  type        = string
  default     = "shared-services"
}

variable "shared_services_secondary_range_cidr" {
  description = "CIDR block for shared services services secondary range"
  type        = string
  default     = "10.12.0.0/20"
}

# Dev Spoke Configuration
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

variable "dev_pods_secondary_range_name" {
  description = "Secondary range name for dev pods"
  type        = string
  default     = "dev-pods"
}

variable "dev_pods_secondary_range_cidr" {
  description = "CIDR block for dev pods secondary range"
  type        = string
  default     = "10.21.0.0/16"
}

variable "dev_services_secondary_range_name" {
  description = "Secondary range name for dev services"
  type        = string
  default     = "dev-services"
}

variable "dev_services_secondary_range_cidr" {
  description = "CIDR block for dev services secondary range"
  type        = string
  default     = "10.22.0.0/20"
}

# Prod Spoke Configuration
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

variable "prod_pods_secondary_range_name" {
  description = "Secondary range name for prod pods"
  type        = string
  default     = "prod-pods"
}

variable "prod_pods_secondary_range_cidr" {
  description = "CIDR block for prod pods secondary range"
  type        = string
  default     = "10.31.0.0/16"
}

variable "prod_services_secondary_range_name" {
  description = "Secondary range name for prod services"
  type        = string
  default     = "prod-services"
}

variable "prod_services_secondary_range_cidr" {
  description = "CIDR block for prod services secondary range"
  type        = string
  default     = "10.32.0.0/20"
}

# Sandbox Spoke Configuration
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

variable "sandbox_pods_secondary_range_name" {
  description = "Secondary range name for sandbox pods"
  type        = string
  default     = "sandbox-pods"
}

variable "sandbox_pods_secondary_range_cidr" {
  description = "CIDR block for sandbox pods secondary range"
  type        = string
  default     = "10.41.0.0/16"
}

variable "sandbox_services_secondary_range_name" {
  description = "Secondary range name for sandbox services"
  type        = string
  default     = "sandbox-services"
}

variable "sandbox_services_secondary_range_cidr" {
  description = "CIDR block for sandbox services secondary range"
  type        = string
  default     = "10.42.0.0/20"
}
