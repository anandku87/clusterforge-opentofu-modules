module "landing_zone" {
  source = "../../blueprints/landing-zone"

  shared_project_id  = var.shared_project_id
  dev_project_id     = var.dev_project_id
  prod_project_id    = var.prod_project_id
  sandbox_project_id = var.sandbox_project_id

  region = var.region
}
