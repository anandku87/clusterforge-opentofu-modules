# ClusterForge Landing Zone Blueprint

This blueprint provides a complete, production-ready example of deploying the ClusterForge landing zone network using OpenTofu.

## Quick Start

### Prerequisites

1. OpenTofu >= 1.8.0 installed
2. Google Cloud SDK (gcloud) configured with appropriate credentials
3. GCP Project with the Compute API enabled
4. Appropriate IAM permissions (Compute Network Admin, Compute Admin)

### Deploy the Landing Zone

```bash
# Configure your variables
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your GCP project ID
# Example:
# project_id = "my-gcp-project-12345"

# Initialize OpenTofu
tofu init

# Review the planned changes
tofu plan

# Apply the configuration
tofu apply
```

## Configuration

### Required Variables

- `project_id`: Your GCP Project ID (required)

### Optional Variables

All other variables have sensible defaults:

```hcl
region                 = "us-central1"
shared_vpc_name        = "shared-services-vpc"
shared_subnet_cidr     = "10.10.0.0/24"
dev_vpc_name           = "dev-vpc"
dev_subnet_cidr        = "10.20.0.0/24"
prod_vpc_name          = "prod-vpc"
prod_subnet_cidr       = "10.30.0.0/24"
sandbox_vpc_name       = "sandbox-vpc"
sandbox_subnet_cidr    = "10.40.0.0/24"
```

## What Gets Created

### Networks
- **shared-services-vpc**: Hub network in clusterforge-shared project
- **dev-vpc**: Dev environment spoke network
- **prod-vpc**: Production environment spoke network
- **sandbox-vpc**: Sandbox environment spoke network

### Subnets
- One subnet per VPC with the specified CIDR ranges
- Private Google Access enabled for GCP service integration
- Flow logging enabled for network observability

### Peering
- 6 bidirectional peering connections (3 hub-to-spoke pairs)
- Custom routes and public subnet routes enabled
- No spoke-to-spoke peering (by design)

## After Deployment

### Verify the Network

```bash
# List the created VPCs
gcloud compute networks list \
  --filter="name:(shared-services-vpc OR dev-vpc OR prod-vpc OR sandbox-vpc)"

# View peering connections
gcloud compute networks peerings list \
  --network=shared-services-vpc

# Inspect a specific VPC
gcloud compute networks describe shared-services-vpc
```

### Next Steps

1. **Deploy GKE Clusters**: Use the `modules/gke` module to deploy clusters in each spoke
2. **Configure Firewall Rules**: Add firewall rules to restrict traffic as needed
3. **Set Up DNS**: Configure Cloud DNS or external DNS in the hub for service discovery
4. **Deploy Shared Services**: Deploy monitoring, logging, and artifact registry in the hub
5. **Enable Workload Identity**: Configure Workload Identity for pod-to-Google-service authentication

## Outputs

After applying, review the outputs to get network information:

```bash
tofu output

# Or get a specific output
tofu output shared_vpc_id
tofu output hub_network_info
tofu output spoke_networks_info
```

### Key Outputs

- `hub_network_info`: Hub VPC details (name, ID, subnet, CIDR)
- `spoke_networks_info`: All spoke details in a single map
- `peering_connections`: All peering connection IDs
- Individual VPC and subnet IDs for reference

## State Management

### Local State (Development)

The blueprint uses local state by default. For development/testing:

```bash
# State file is stored locally
cat terraform.tfstate
```

### Remote State (Production)

For production deployments, configure remote state:

```hcl
# Add to main.tf or create a backend.tf
terraform {
  backend "gcs" {
    bucket = "my-terraform-state-bucket"
    prefix = "clusterforge/landing-zone"
  }
}
```

Then run:
```bash
tofu init -migrate-state
```

## Cleanup

To remove the landing zone network:

```bash
# Ensure no resources depend on the VPCs
# (e.g., delete GKE clusters first)

tofu destroy

# Confirm the destruction
```

## Customization

### Changing CIDR Ranges

Modify the CIDR values in terraform.tfvars:

```hcl
shared_subnet_cidr = "10.100.0.0/24"  # Changed from 10.10.0.0/24
dev_subnet_cidr    = "10.101.0.0/24"  # Changed from 10.20.0.0/24
```

### Changing VPC Names

Update the VPC names:

```hcl
shared_vpc_name = "platform-hub-vpc"
dev_vpc_name    = "development-spoke-vpc"
```

### Deploying to Additional Regions

Create a second instance of the blueprint in a new region:

```bash
# Create a new directory
mkdir blueprints/landing-zone-us-east1

# Copy the blueprint files
cp blueprints/landing-zone/*.tf blueprints/landing-zone-us-east1/

# Update terraform.tfvars
sed -i 's/us-central1/us-east1/g' blueprints/landing-zone-us-east1/terraform.tfvars

# Update CIDR ranges to avoid conflicts (use the reserved ranges)
# shared_subnet_cidr = "10.11.0.0/24"
# dev_subnet_cidr    = "10.21.0.0/24"
# prod_subnet_cidr   = "10.31.0.0/24"
# sandbox_subnet_cidr = "10.41.0.0/24"

# Deploy
cd blueprints/landing-zone-us-east1
tofu init
tofu apply
```

## Troubleshooting

### Peering Connection Not Established

1. Verify project IDs match
2. Check IAM permissions for VPC peering
3. Review Cloud Audit Logs for error details:
   ```bash
   gcloud logging read "resource.type=gce_network AND protoPayload.methodName=v1.compute.networks.addPeering" --limit 10
   ```

### Cannot Apply Due to Existing Resources

If VPCs already exist:

```bash
# Import existing resources
tofu import google_compute_network.shared_services shared-services-vpc

# Then re-run plan and apply
tofu plan
```

### CIDR Range Conflict

Ensure all CIDR ranges are non-overlapping and follow the allocation strategy documented in the landing zone architecture.

## Performance Considerations

- VPC peering latency: < 1ms within a region
- Cross-region peering: < 10ms typically
- Flow logging: 50% sampling (adjust if needed)
- Scale: One blueprint deploys 4 VPCs and 6 peerings

## Cost Optimization

- VPC creation and peering are free
- Flow logs incur Cloud Logging costs (adjust sampling as needed)
- Optimize sampling rate: `flow_sampling = 0.1` for 10% sampling

## File Structure

```
blueprints/landing-zone/
├── main.tf                      # Module instantiation
├── variables.tf                 # Blueprint variables
├── outputs.tf                   # Output definitions
├── terraform.tfvars.example     # Example configuration
└── README.md                    # This file
```

## Module Reference

For detailed module documentation and options, see:
- [Landing Zone Network Module](../../modules/landing-zone-network/README.md)
- [Module Source Code](../../modules/landing-zone-network/)

## Architecture Documentation

For the overall landing zone architecture design:
- [Landing Zone V2 Documentation](../../docs/landing-zone-v2.md)
- [Hub-and-Spoke Architecture](../../docs/landing-zone-v2.md#5-hub-and-spoke-networking)

## Support & Contributions

For issues, questions, or improvements:
1. Review the documentation and troubleshooting section
2. Check existing issues in the repository
3. Submit a pull request with improvements
4. Contact the platform engineering team

## Related Modules

Other modules in ClusterForge:
- `modules/gke`: Deploy GKE clusters into spokes
- `modules/addons`: Platform add-ons (ArgoCD, ingress, etc.)
- `modules/security`: Security and access controls
- `modules/shared-services`: Shared platform services

## License

This blueprint is part of ClusterForge and follows the repository's license terms.
