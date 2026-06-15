module "shared_services" {
  source = "../../blueprints/shared-services"

  project_id = var.project_id
  region     = var.region

  state_bucket_name      = var.state_bucket_name
  artifact_registry_name = var.artifact_registry_name
  service_account_name   = var.service_account_name
}
