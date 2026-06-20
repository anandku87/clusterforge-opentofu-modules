# Hub VPC Outputs
output "shared_vpc_id" {
  description = "Resource ID of the shared services hub VPC"
  value       = google_compute_network.shared_services.id
}

output "shared_vpc_self_link" {
  description = "Self link of the shared services hub VPC"
  value       = google_compute_network.shared_services.self_link
}

output "shared_subnet_id" {
  description = "Resource ID of the shared services subnet"
  value       = google_compute_subnetwork.shared_services.id
}

output "shared_subnet_self_link" {
  description = "Self link of the shared services subnet"
  value       = google_compute_subnetwork.shared_services.self_link
}

# Dev VPC Outputs
output "dev_vpc_id" {
  description = "Resource ID of the development spoke VPC"
  value       = google_compute_network.dev.id
}

output "dev_vpc_self_link" {
  description = "Self link of the development spoke VPC"
  value       = google_compute_network.dev.self_link
}

output "dev_subnet_id" {
  description = "Resource ID of the development subnet"
  value       = google_compute_subnetwork.dev.id
}

output "dev_subnet_self_link" {
  description = "Self link of the development subnet"
  value       = google_compute_subnetwork.dev.self_link
}

# Prod VPC Outputs
output "prod_vpc_id" {
  description = "Resource ID of the production spoke VPC"
  value       = google_compute_network.prod.id
}

output "prod_vpc_self_link" {
  description = "Self link of the production spoke VPC"
  value       = google_compute_network.prod.self_link
}

output "prod_subnet_id" {
  description = "Resource ID of the production subnet"
  value       = google_compute_subnetwork.prod.id
}

output "prod_subnet_self_link" {
  description = "Self link of the production subnet"
  value       = google_compute_subnetwork.prod.self_link
}

# Sandbox VPC Outputs
output "sandbox_vpc_id" {
  description = "Resource ID of the sandbox spoke VPC"
  value       = google_compute_network.sandbox.id
}

output "sandbox_vpc_self_link" {
  description = "Self link of the sandbox spoke VPC"
  value       = google_compute_network.sandbox.self_link
}

output "sandbox_subnet_id" {
  description = "Resource ID of the sandbox subnet"
  value       = google_compute_subnetwork.sandbox.id
}

output "sandbox_subnet_self_link" {
  description = "Self link of the sandbox subnet"
  value       = google_compute_subnetwork.sandbox.self_link
}

# Peering Outputs
output "peering_connections" {
  description = "Map of all peering connections"
  value = {
    shared_to_dev     = google_compute_network_peering.shared_to_dev.id
    dev_to_shared     = google_compute_network_peering.dev_to_shared.id
    shared_to_prod    = google_compute_network_peering.shared_to_prod.id
    prod_to_shared    = google_compute_network_peering.prod_to_shared.id
    shared_to_sandbox = google_compute_network_peering.shared_to_sandbox.id
    sandbox_to_shared = google_compute_network_peering.sandbox_to_shared.id
  }
}

# Summary Outputs
output "hub_network_info" {
  description = "Hub network summary information"
  value = {
    name      = var.shared_vpc_name
    vpc_id    = google_compute_network.shared_services.id
    subnet_id = google_compute_subnetwork.shared_services.id
    cidr      = var.shared_subnet_cidr
  }
}

output "spoke_networks_info" {
  description = "Spoke networks summary information"
  value = {
    dev = {
      name      = var.dev_vpc_name
      vpc_id    = google_compute_network.dev.id
      subnet_id = google_compute_subnetwork.dev.id
      cidr      = var.dev_subnet_cidr
    }
    prod = {
      name      = var.prod_vpc_name
      vpc_id    = google_compute_network.prod.id
      subnet_id = google_compute_subnetwork.prod.id
      cidr      = var.prod_subnet_cidr
    }
    sandbox = {
      name      = var.sandbox_vpc_name
      vpc_id    = google_compute_network.sandbox.id
      subnet_id = google_compute_subnetwork.sandbox.id
      cidr      = var.sandbox_subnet_cidr
    }
  }
}
