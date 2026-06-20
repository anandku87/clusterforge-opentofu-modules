terraform {
  required_version = ">= 1.8.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Landing Zone Network Module
module "landing_zone_network" {
  source = "../../modules/landing-zone-network"

  project_id = var.project_id
  region     = var.region

  # Hub Configuration
  shared_vpc_name    = var.shared_vpc_name
  shared_subnet_cidr = var.shared_subnet_cidr

  # Dev Spoke Configuration
  dev_vpc_name    = var.dev_vpc_name
  dev_subnet_cidr = var.dev_subnet_cidr

  # Prod Spoke Configuration
  prod_vpc_name    = var.prod_vpc_name
  prod_subnet_cidr = var.prod_subnet_cidr

  # Sandbox Spoke Configuration
  sandbox_vpc_name    = var.sandbox_vpc_name
  sandbox_subnet_cidr = var.sandbox_subnet_cidr
}
