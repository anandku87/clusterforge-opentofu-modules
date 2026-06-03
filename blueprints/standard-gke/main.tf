module "network" {
  source = "../../modules/network"

  project_id = var.project_id
  region     = var.region

  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name

  subnet_cidr   = var.subnet_cidr
  pods_cidr     = var.pods_cidr
  services_cidr = var.services_cidr
}

module "gke" {
  source = "../../modules/gke"

  project_id   = var.project_id
  cluster_name = var.cluster_name
  region       = var.region

  network = module.network.vpc_name
  subnetwork = module.network.subnet_name

  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name

  machine_type = var.machine_type

  node_count = var.node_count
  min_nodes  = var.min_nodes
  max_nodes  = var.max_nodes

  disk_size = var.disk_size

  deletion_protection = var.deletion_protection
}

module "security" {
  source = "../../modules/security"

  project_id                   = var.project_id
  service_account_name         = "argocd"
  service_account_display_name = "ArgoCD Service Account"
  kubernetes_namespace         = "argocd"
  kubernetes_service_account   = "argocd-server"

  roles = [
    "roles/container.viewer",
    "roles/artifactregistry.reader",
    "roles/secretmanager.secretAccessor",
  ]
}