module "network" {
  source = "../../modules/network"

  project_id = "clusterforge-dev"
  region     = "asia-south1"

  vpc_name    = "clusterforge-vpc"
  subnet_name = "clusterforge-subnet"

  subnet_cidr   = "10.10.0.0/20"
  pods_cidr     = "10.20.0.0/16"
  services_cidr = "10.30.0.0/20"
}

module "security" {
  source = "../../modules/security"

  project_id                   = "clusterforge-dev"
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