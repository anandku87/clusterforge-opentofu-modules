# Landing Zone Network Module

A reusable OpenTofu module that implements a Hub-and-Spoke landing zone network architecture for ClusterForge on Google Cloud Platform.

## Overview

This module provisions the foundational network infrastructure for ClusterForge:
- 1 Hub VPC (shared-services-vpc) with centralized services
- 3 Spoke VPCs (dev-vpc, prod-vpc, sandbox-vpc) for environment-specific workloads
- Bidirectional VPC peering between hub and each spoke
- Subnets with private Google access and flow logging enabled
- Full support for GKE cluster deployment

## Architecture

```
                 shared-services-vpc
                    (Hub Network)
                      10.10.0.0/24
                          |
         ---------------------------------
         |               |              |
      dev-vpc        prod-vpc      sandbox-vpc
    10.20.0.0/24   10.30.0.0/24   10.40.0.0/24
    (Dev Spoke)    (Prod Spoke)    (Sandbox Spoke)
```

### Key Characteristics

- **Hub-and-Spoke Topology**: Centralized hub with isolated spokes
- **No Spoke-to-Spoke Peering**: All inter-spoke traffic routes through the hub
- **Bidirectional Routing**: Custom routes and public subnet routes exported/imported
- **Flow Logging**: Enabled on all subnets for observability
- **Private Google Access**: Enabled for all subnets for GCP service access
- **Scalable Design**: CIDR plan supports multi-region expansion

## Prerequisites

- OpenTofu >= 1.8.0
- Google Cloud Provider >= 5.0
- GCP Project with appropriate permissions
- gcloud CLI configured with default project

## Usage

### Basic Module Usage

```hcl
module "landing_zone_network" {
  source = "../../modules/landing-zone-network"

  project_id = "my-gcp-project"
  region     = "us-central1"

  shared_vpc_name    = "shared-services-vpc"
  shared_subnet_cidr = "10.10.0.0/24"

  dev_vpc_name    = "dev-vpc"
  dev_subnet_cidr = "10.20.0.0/24"

  prod_vpc_name    = "prod-vpc"
  prod_subnet_cidr = "10.30.0.0/24"

  sandbox_vpc_name    = "sandbox-vpc"
  sandbox_subnet_cidr = "10.40.0.0/24"
}
```

### Using the Blueprint

A pre-configured blueprint is provided for easy deployment:

```bash
cd blueprints/landing-zone

# Copy and configure the terraform.tfvars file
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your GCP project ID

# Initialize OpenTofu
tofu init

# Review planned changes
tofu plan

# Apply the configuration
tofu apply
```

### Example terraform.tfvars

```hcl
project_id = "my-gcp-project-12345"
region     = "us-central1"

# Hub VPC Configuration
shared_vpc_name    = "shared-services-vpc"
shared_subnet_cidr = "10.10.0.0/24"

# Dev Spoke Configuration
dev_vpc_name    = "dev-vpc"
dev_subnet_cidr = "10.20.0.0/24"

# Prod Spoke Configuration
prod_vpc_name    = "prod-vpc"
prod_subnet_cidr = "10.30.0.0/24"

# Sandbox Spoke Configuration
sandbox_vpc_name    = "sandbox-vpc"
sandbox_subnet_cidr = "10.40.0.0/24"
```

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `project_id` | string | N/A | GCP Project ID (required) |
| `region` | string | `us-central1` | GCP region for all resources |
| `shared_vpc_name` | string | `shared-services-vpc` | Name of the hub VPC |
| `shared_subnet_cidr` | string | `10.10.0.0/24` | CIDR block for hub subnet |
| `dev_vpc_name` | string | `dev-vpc` | Name of the dev spoke VPC |
| `dev_subnet_cidr` | string | `10.20.0.0/24` | CIDR block for dev subnet |
| `prod_vpc_name` | string | `prod-vpc` | Name of the prod spoke VPC |
| `prod_subnet_cidr` | string | `10.30.0.0/24` | CIDR block for prod subnet |
| `sandbox_vpc_name` | string | `sandbox-vpc` | Name of the sandbox spoke VPC |
| `sandbox_subnet_cidr` | string | `10.40.0.0/24` | CIDR block for sandbox subnet |

## Outputs

### Primary Outputs

- `shared_vpc_id` - VPC ID of the hub network
- `dev_vpc_id` - VPC ID of the dev spoke
- `prod_vpc_id` - VPC ID of the prod spoke
- `sandbox_vpc_id` - VPC ID of the sandbox spoke
- `shared_subnet_id` - Subnet ID of the hub network
- `dev_subnet_id` - Subnet ID of the dev spoke
- `prod_subnet_id` - Subnet ID of the prod spoke
- `sandbox_subnet_id` - Subnet ID of the sandbox spoke

### Summary Outputs

- `hub_network_info` - Map containing hub VPC name, ID, subnet ID, and CIDR
- `spoke_networks_info` - Map of all spoke networks with their details
- `peering_connections` - Map of all VPC peering connections

### Self Links

The module also exports `self_link` outputs for VPCs and subnets, useful for referencing in dependent resources.

## CIDR Allocation Strategy

The module uses a structured CIDR allocation plan to support multi-region expansion:

```
Hub (10.10.0.0/16):
  - Primary Region: 10.10.0.0/24
  - Regional Expansion: 10.11.0.0/24 - 10.19.0.0/24

Dev (10.20.0.0/16):
  - Primary Region: 10.20.0.0/24
  - Regional Expansion: 10.21.0.0/24 - 10.29.0.0/24

Prod (10.30.0.0/16):
  - Primary Region: 10.30.0.0/24
  - Regional Expansion: 10.31.0.0/24 - 10.39.0.0/24

Sandbox (10.40.0.0/16):
  - Primary Region: 10.40.0.0/24
  - Regional Expansion: 10.41.0.0/24 - 10.49.0.0/24
```

## Network Features

### VPC Configuration
- Regional routing mode for predictable multi-region support
- Auto subnet creation disabled for fine-grained control
- Custom network naming for clarity and operations

### Subnet Features
- Private Google Access enabled for all subnets
- Flow logging enabled with:
  - 5-second aggregation interval
  - 50% traffic sampling
  - Full metadata collection
- Sufficient address space for GKE clusters and services

### VPC Peering
- Bidirectional peering relationships between hub and spokes
- Custom route import/export enabled
- Public subnet routes included in peering
- Automatic dependency management (reverse peering depends on forward)

## Connectivity Validation

After deployment, validate the network topology:

```bash
# List VPCs
gcloud compute networks list \
  --project=my-gcp-project \
  --filter="name:(shared-services-vpc OR dev-vpc OR prod-vpc OR sandbox-vpc)"

# List peering connections
gcloud compute networks peerings list \
  --network=shared-services-vpc \
  --project=my-gcp-project

# Test connectivity (after GKE deployment)
# Create test pods in different VPCs and verify ping:
kubectl exec -it <pod-in-dev> -- ping <ip-in-prod-vpc>
# Should fail (no direct spoke-to-spoke peering)

kubectl exec -it <pod-in-dev> -- ping <ip-in-hub>
# Should succeed (hub peering)
```

## Security Considerations

This module creates the network foundation only. Additional security controls should be implemented:

1. **Firewall Rules**: Define rules to restrict traffic between VPCs based on your security requirements
2. **Private GKE**: Deploy private GKE clusters (no public IPs for nodes)
3. **Network Policies**: Implement Kubernetes network policies for pod-level isolation
4. **Service Accounts**: Use Workload Identity with least-privilege IAM roles
5. **VPC Service Controls**: Consider implementing VPC Service Controls for additional boundary protection

## Troubleshooting

### Peering Connection Issues

If peering doesn't establish:
1. Verify project IDs in `project_id` variable
2. Check IAM permissions for VPC peering
3. Ensure no overlapping CIDR ranges
4. Review firewall rules blocking ICMP

### Route not appearing in peer VPCs

1. Verify `import_custom_routes` is enabled on peering
2. Check if routes are marked as custom or system routes
3. Verify routing mode is REGIONAL on both VPCs

### Subnet connectivity problems

1. Verify subnets are in the same region
2. Check Private Google Access configuration
3. Review flow logs to identify dropped packets

## Multi-Region Expansion

To expand to additional regions:

1. Define new subnets in the reserved CIDR ranges
2. Create new `google_compute_subnetwork` resources
3. Set `region` variable to the new region
4. Peering automatically works across regions

Example for adding us-east1 region:

```hcl
# Add new subnet in us-east1 for hub
resource "google_compute_subnetwork" "shared_services_east" {
  name          = "shared-services-vpc-east-subnet"
  project       = var.project_id
  region        = "us-east1"
  network       = google_compute_network.shared_services.id
  ip_cidr_range = "10.11.0.0/24"

  private_ip_google_access = true
  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
```

## Maintenance

### Flow Log Sampling

The module samples 50% of traffic for cost optimization. Adjust in `main.tf`:
```hcl
flow_sampling = 0.5  # Change to 1.0 for 100% sampling
```

### Adding Custom Routes

After module deployment, routes can be added to VPCs:
```bash
gcloud compute routes create my-custom-route \
  --network=shared-services-vpc \
  --destination-range=0.0.0.0/0 \
  --next-hop-gateway=default-internet-gateway \
  --project=my-gcp-project
```

## Documentation

For more details on the ClusterForge landing zone architecture, see:
- [Landing Zone V2 Documentation](../../docs/landing-zone-v2.md)
- [Hub-and-Spoke Architecture](../../docs/landing-zone-v2.md#5-hub-and-spoke-networking)
- [CIDR Allocation Strategy](../../docs/landing-zone-v2.md#6-cidr-allocation-strategy)

## Cost Estimation

The module creates resources that incur minimal costs:
- VPCs: Free
- Subnets: Free
- VPC Peering: $0.02/GB for cross-region traffic
- Flow Logs: Configurable sampling (50% default)

## Support

For issues or improvements, contact the platform engineering team or submit pull requests following the repository contribution guidelines.

## License

This module is part of ClusterForge and follows the repository's license terms.
