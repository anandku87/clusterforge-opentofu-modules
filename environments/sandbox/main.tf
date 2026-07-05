module "standard" {
  source = "../../blueprints/standard-gke"

  project_id   = var.project_id
  cluster_name = var.cluster_name
  region       = var.region

  network    = data.terraform_remote_state.landing_zone.outputs.sandbox_network_name
  subnetwork = data.terraform_remote_state.landing_zone.outputs.sandbox_subnet_name

  pods_range_name     = data.terraform_remote_state.landing_zone.outputs.sandbox_pods_secondary_range_name
  services_range_name = data.terraform_remote_state.landing_zone.outputs.sandbox_services_secondary_range_name

  machine_type = var.machine_type

  node_count = var.node_count
  min_nodes  = var.min_nodes
  max_nodes  = var.max_nodes

  disk_size = var.disk_size


  deletion_protection = var.deletion_protection
}