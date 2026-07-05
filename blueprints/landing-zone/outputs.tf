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

output "shared_vpc_self_link" {
  description = "Self link of the shared services hub VPC"
  value       = module.landing_zone_network.shared_vpc_self_link
}

output "shared_subnet_self_link" {
  description = "Self link of the shared services subnet"
  value       = module.landing_zone_network.shared_subnet_self_link
}

output "shared_pods_secondary_range_name" {
  description = "Pods secondary range name for shared services"
  value       = module.landing_zone_network.shared_pods_secondary_range_name
}

output "shared_services_secondary_range_name" {
  description = "Services secondary range name for shared services"
  value       = module.landing_zone_network.shared_services_secondary_range_name
}

output "dev_vpc_self_link" {
  description = "Self link of the development spoke VPC"
  value       = module.landing_zone_network.dev_vpc_self_link
}

output "dev_subnet_self_link" {
  description = "Self link of the development subnet"
  value       = module.landing_zone_network.dev_subnet_self_link
}

output "dev_pods_secondary_range_name" {
  description = "Pods secondary range name for dev"
  value       = module.landing_zone_network.dev_pods_secondary_range_name
}

output "dev_services_secondary_range_name" {
  description = "Services secondary range name for dev"
  value       = module.landing_zone_network.dev_services_secondary_range_name
}

output "prod_vpc_self_link" {
  description = "Self link of the production spoke VPC"
  value       = module.landing_zone_network.prod_vpc_self_link
}

output "prod_subnet_self_link" {
  description = "Self link of the production subnet"
  value       = module.landing_zone_network.prod_subnet_self_link
}

output "prod_pods_secondary_range_name" {
  description = "Pods secondary range name for prod"
  value       = module.landing_zone_network.prod_pods_secondary_range_name
}

output "prod_services_secondary_range_name" {
  description = "Services secondary range name for prod"
  value       = module.landing_zone_network.prod_services_secondary_range_name
}

output "sandbox_vpc_self_link" {
  description = "Self link of the sandbox spoke VPC"
  value       = module.landing_zone_network.sandbox_vpc_self_link
}

output "sandbox_subnet_self_link" {
  description = "Self link of the sandbox subnet"
  value       = module.landing_zone_network.sandbox_subnet_self_link
}

output "sandbox_network_name" {
  value = module.landing_zone_network.sandbox_network_name
}

output "sandbox_subnet_name" {
  value = module.landing_zone_network.sandbox_subnet_name
}

output "sandbox_pods_secondary_range_name" {
  value = module.landing_zone_network.sandbox_pods_secondary_range_name
}

output "sandbox_services_secondary_range_name" {
  value = module.landing_zone_network.sandbox_services_secondary_range_name
}