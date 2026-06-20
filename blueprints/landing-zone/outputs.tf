output "hub_network_info" {
  description = "Hub network summary information"
  value       = module.landing_zone_network.hub_network_info
}

output "spoke_networks_info" {
  description = "Spoke networks summary information"
  value       = module.landing_zone_network.spoke_networks_info
}

output "peering_connections" {
  description = "Map of all peering connections"
  value       = module.landing_zone_network.peering_connections
}

output "shared_vpc_id" {
  description = "Resource ID of the shared services hub VPC"
  value       = module.landing_zone_network.shared_vpc_id
}

output "dev_vpc_id" {
  description = "Resource ID of the development spoke VPC"
  value       = module.landing_zone_network.dev_vpc_id
}

output "prod_vpc_id" {
  description = "Resource ID of the production spoke VPC"
  value       = module.landing_zone_network.prod_vpc_id
}

output "sandbox_vpc_id" {
  description = "Resource ID of the sandbox spoke VPC"
  value       = module.landing_zone_network.sandbox_vpc_id
}

output "shared_subnet_id" {
  description = "Resource ID of the shared services subnet"
  value       = module.landing_zone_network.shared_subnet_id
}

output "dev_subnet_id" {
  description = "Resource ID of the development subnet"
  value       = module.landing_zone_network.dev_subnet_id
}

output "prod_subnet_id" {
  description = "Resource ID of the production subnet"
  value       = module.landing_zone_network.prod_subnet_id
}

output "sandbox_subnet_id" {
  description = "Resource ID of the sandbox subnet"
  value       = module.landing_zone_network.sandbox_subnet_id
}
