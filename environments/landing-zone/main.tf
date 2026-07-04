module "landing_zone" {
  source = "../../blueprints/landing-zone"

  shared_project_id  = "clusterforge-shared"
  dev_project_id     = "clusterforge-dev"
  prod_project_id    = "clusterforge-prod"
  sandbox_project_id = "clusterforge-sandbox"

  region = "asia-south1"
}
