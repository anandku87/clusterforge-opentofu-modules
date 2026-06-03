module "standard" {
  source = "../../blueprints/standard-gke"

  project_id   = var.project_id
  cluster_name = var.cluster_name
  region       = var.region

  machine_type = var.machine_type

  node_count = var.node_count
  min_nodes  = var.min_nodes
  max_nodes  = var.max_nodes

  disk_size = var.disk_size

  deletion_protection = var.deletion_protection
}
