# Hub VPC
resource "google_compute_network" "shared_services" {
  name                    = var.shared_vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Shared Services Subnet
resource "google_compute_subnetwork" "shared_services" {
  name          = "${var.shared_vpc_name}-subnet"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.shared_services.id
  ip_cidr_range = var.shared_subnet_cidr

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Dev VPC (Spoke)
resource "google_compute_network" "dev" {
  name                    = var.dev_vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Dev Subnet
resource "google_compute_subnetwork" "dev" {
  name          = "${var.dev_vpc_name}-subnet"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.dev.id
  ip_cidr_range = var.dev_subnet_cidr

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Prod VPC (Spoke)
resource "google_compute_network" "prod" {
  name                    = var.prod_vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Prod Subnet
resource "google_compute_subnetwork" "prod" {
  name          = "${var.prod_vpc_name}-subnet"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.prod.id
  ip_cidr_range = var.prod_subnet_cidr

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Sandbox VPC (Spoke)
resource "google_compute_network" "sandbox" {
  name                    = var.sandbox_vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Sandbox Subnet
resource "google_compute_subnetwork" "sandbox" {
  name          = "${var.sandbox_vpc_name}-subnet"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.sandbox.id
  ip_cidr_range = var.sandbox_subnet_cidr

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Peering: Shared Services Hub <-> Dev Spoke
resource "google_compute_network_peering" "shared_to_dev" {
  name         = "${var.shared_vpc_name}-to-${var.dev_vpc_name}"
  network      = google_compute_network.shared_services.self_link
  peer_network = google_compute_network.dev.self_link

  import_custom_routes                = true
  export_custom_routes                = true
  export_subnet_routes_with_public_ip = true
  import_subnet_routes_with_public_ip = true
}

resource "google_compute_network_peering" "dev_to_shared" {
  name         = "${var.dev_vpc_name}-to-${var.shared_vpc_name}"
  network      = google_compute_network.dev.self_link
  peer_network = google_compute_network.shared_services.self_link

  import_custom_routes                = true
  export_custom_routes                = true
  export_subnet_routes_with_public_ip = true
  import_subnet_routes_with_public_ip = true

  depends_on = [google_compute_network_peering.shared_to_dev]
}

# Peering: Shared Services Hub <-> Prod Spoke
resource "google_compute_network_peering" "shared_to_prod" {
  name         = "${var.shared_vpc_name}-to-${var.prod_vpc_name}"
  network      = google_compute_network.shared_services.self_link
  peer_network = google_compute_network.prod.self_link

  import_custom_routes                = true
  export_custom_routes                = true
  export_subnet_routes_with_public_ip = true
  import_subnet_routes_with_public_ip = true
}

resource "google_compute_network_peering" "prod_to_shared" {
  name         = "${var.prod_vpc_name}-to-${var.shared_vpc_name}"
  network      = google_compute_network.prod.self_link
  peer_network = google_compute_network.shared_services.self_link

  import_custom_routes                = true
  export_custom_routes                = true
  export_subnet_routes_with_public_ip = true
  import_subnet_routes_with_public_ip = true

  depends_on = [google_compute_network_peering.shared_to_prod]
}

# Peering: Shared Services Hub <-> Sandbox Spoke
resource "google_compute_network_peering" "shared_to_sandbox" {
  name         = "${var.shared_vpc_name}-to-${var.sandbox_vpc_name}"
  network      = google_compute_network.shared_services.self_link
  peer_network = google_compute_network.sandbox.self_link

  import_custom_routes                = true
  export_custom_routes                = true
  export_subnet_routes_with_public_ip = true
  import_subnet_routes_with_public_ip = true
}

resource "google_compute_network_peering" "sandbox_to_shared" {
  name         = "${var.sandbox_vpc_name}-to-${var.shared_vpc_name}"
  network      = google_compute_network.sandbox.self_link
  peer_network = google_compute_network.shared_services.self_link

  import_custom_routes                = true
  export_custom_routes                = true
  export_subnet_routes_with_public_ip = true
  import_subnet_routes_with_public_ip = true

  depends_on = [google_compute_network_peering.shared_to_sandbox]
}
