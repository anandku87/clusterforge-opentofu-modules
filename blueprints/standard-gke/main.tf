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