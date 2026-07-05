terraform {
  required_version = ">= 1.8.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  # Provider configuration is optional here; credentials are typically managed
  # via GOOGLE_APPLICATION_CREDENTIALS environment variable or gcloud default credentials
}

# Shared Services Project (Hub)
module "shared_project" {
  source = "../../modules/project-factory"

  project_id      = var.shared_project_id
  project_name    = var.shared_project_name
  billing_account = var.billing_account
  folder_id       = var.folder_id
  environment     = "shared"

  additional_labels = merge(
    var.additional_labels,
    {
      project_type = "hub"
    }
  )

  create_platform_service_account = var.create_platform_service_accounts
}

# Development Project (Spoke)
module "dev_project" {
  source = "../../modules/project-factory"

  project_id      = var.dev_project_id
  project_name    = var.dev_project_name
  billing_account = var.billing_account
  folder_id       = var.folder_id
  environment     = "dev"

  additional_labels = merge(
    var.additional_labels,
    {
      project_type = "spoke"
    }
  )

  create_platform_service_account = var.create_platform_service_accounts
}

# Production Project (Spoke)
module "prod_project" {
  source = "../../modules/project-factory"

  project_id      = var.prod_project_id
  project_name    = var.prod_project_name
  billing_account = var.billing_account
  folder_id       = var.folder_id
  environment     = "prod"

  additional_labels = merge(
    var.additional_labels,
    {
      project_type = "spoke"
    }
  )

  create_platform_service_account = var.create_platform_service_accounts
}

# Sandbox Project (Spoke)
module "sandbox_project" {
  source = "../../modules/project-factory"

  project_id      = var.sandbox_project_id
  project_name    = var.sandbox_project_name
  billing_account = var.billing_account
  folder_id       = var.folder_id
  environment     = "sandbox"

  additional_labels = merge(
    var.additional_labels,
    {
      project_type = "spoke"
    }
  )

  create_platform_service_account = var.create_platform_service_accounts
}
