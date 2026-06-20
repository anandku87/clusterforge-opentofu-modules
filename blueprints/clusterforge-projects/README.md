# ClusterForge Projects Blueprint

A complete blueprint for provisioning all four ClusterForge projects (shared, dev, prod, sandbox) in GCP using the project-factory module.

## Overview

This blueprint automates the creation of the ClusterForge multi-project landing zone:

```
GCP Organization / Folder
├── clusterforge-shared     (Hub Project)
├── clusterforge-dev        (Dev Spoke Project)
├── clusterforge-prod       (Prod Spoke Project)
└── clusterforge-sandbox    (Sandbox Spoke Project)
```

All projects are created with:
- Standard ClusterForge labels (platform, managed_by, environment)
- Required Google Cloud services automatically enabled
- Optional platform service accounts
- Consistent naming and configuration

## Prerequisites

- OpenTofu >= 1.8.0
- Google Cloud SDK (gcloud) installed and configured
- A valid GCP billing account
- Appropriate IAM permissions:
  - `roles/resourcemanager.projectCreator` (Project Creator)
  - `roles/serviceusage.serviceUsageAdmin` (Service Usage Admin)
  - `roles/iam.serviceAccountAdmin` (if creating service accounts)
- GCP organization or folder (optional, for `folder_id`)

## Quick Start

### 1. Configure Variables

```bash
# Copy the example configuration
cp terraform.tfvars.example terraform.tfvars

# Edit with your billing account ID
# Open terraform.tfvars and update:
# - billing_account: Your billing account ID (required)
# - folder_id: Optional folder ID for project organization
```

### 2. Get Your Billing Account ID

```bash
gcloud billing accounts list --format="value(name)"
```

Output format: `billingAccounts/01AB23-CD45EF-G6HI90`

Use only the alphanumeric part in terraform.tfvars: `01AB23-CD45EF-G6HI90`

### 3. Find Optional Folder ID

```bash
gcloud resource-manager folders list --organization=YOUR_ORG_ID
```

Use the folder ID if you want projects organized under a specific folder.

### 4. Initialize OpenTofu

```bash
tofu init
```

### 5. Review Planned Changes

```bash
tofu plan
```

This shows:
- 4 projects to be created
- Services to be enabled on each project
- Optional service accounts (if enabled)

### 6. Apply Configuration

```bash
tofu apply
```

Confirm by typing `yes` when prompted.

## Configuration

### Required Variables

#### `billing_account`
The alphanumeric billing account ID to attach all projects to.

```hcl
billing_account = "01AB23-CD45EF-G6HI90"
```

### Optional Variables

#### `folder_id`
Numeric folder ID to organize projects under.

```hcl
folder_id = "123456789012"
```

#### Project IDs & Names
Override default project names if needed:

```hcl
shared_project_id   = "clusterforge-shared"
shared_project_name = "ClusterForge Shared Services"

dev_project_id   = "clusterforge-dev"
dev_project_name = "ClusterForge Development"

prod_project_id   = "clusterforge-prod"
prod_project_name = "ClusterForge Production"

sandbox_project_id   = "clusterforge-sandbox"
sandbox_project_name = "ClusterForge Sandbox"
```

#### `additional_labels`
Custom labels applied to all projects:

```hcl
additional_labels = {
  team        = "platform"
  cost-center = "engineering"
  compliance  = "pci-dss"
}
```

#### `create_platform_service_accounts`
Create platform service accounts in all projects:

```hcl
create_platform_service_accounts = true
```

If enabled, each project gets a `clusterforge-platform` service account.

## What Gets Created

### Projects
- **clusterforge-shared:** Hub project for centralized platform services
- **clusterforge-dev:** Development environment spoke project
- **clusterforge-prod:** Production environment spoke project
- **clusterforge-sandbox:** Sandbox environment spoke project

### Services Enabled (per project)
All projects have these services automatically enabled:
- Compute Engine (compute.googleapis.com)
- Google Kubernetes Engine (container.googleapis.com)
- Artifact Registry (artifactregistry.googleapis.com)
- Secret Manager (secretmanager.googleapis.com)
- IAM (iam.googleapis.com)
- Cloud Resource Manager (cloudresourcemanager.googleapis.com)
- Service Networking (servicenetworking.googleapis.com)
- Cloud Monitoring (monitoring.googleapis.com)
- Cloud Logging (logging.googleapis.com)

### Service Accounts (optional)
If `create_platform_service_accounts = true`:
- Each project gets a `clusterforge-platform` service account
- Email: `clusterforge-platform@<project-id>.iam.gserviceaccount.com`
- No IAM roles attached (add them as needed)

### Labels
All projects receive:
- `platform = clusterforge`
- `managed_by = opentofu`
- `environment = shared|dev|prod|sandbox`
- `project_type = hub|spoke`
- Additional user-supplied labels

## Outputs

After successful deployment, review the outputs:

```bash
tofu output
```

### Key Outputs

#### `all_projects`
Map of all projects with IDs and numbers:

```hcl
{
  shared = {
    project_id     = "clusterforge-shared"
    project_number = "123456789012"
  }
  dev = {
    project_id     = "clusterforge-dev"
    project_number = "123456789013"
  }
  prod = {
    project_id     = "clusterforge-prod"
    project_number = "123456789014"
  }
  sandbox = {
    project_id     = "clusterforge-sandbox"
    project_number = "123456789015"
  }
}
```

#### `platform_service_account_emails`
Email addresses of platform service accounts (if created):

```hcl
{
  shared  = "clusterforge-platform@clusterforge-shared.iam.gserviceaccount.com"
  dev     = "clusterforge-platform@clusterforge-dev.iam.gserviceaccount.com"
  prod    = "clusterforge-platform@clusterforge-prod.iam.gserviceaccount.com"
  sandbox = "clusterforge-platform@clusterforge-sandbox.iam.gserviceaccount.com"
}
```

Individual project outputs:

```bash
tofu output shared_project
tofu output dev_project
tofu output prod_project
tofu output sandbox_project
```

## Post-Deployment Steps

### 1. Switch to New Projects

```bash
gcloud config set project clusterforge-shared
gcloud config set project clusterforge-dev
```

### 2. Set Up Billing Alerts

```bash
gcloud billing accounts describe 01AB23-CD45EF-G6HI90
```

### 3. Configure IAM Bindings

Grant roles to the platform service accounts (if created):

```bash
gcloud projects add-iam-policy-binding clusterforge-shared \
  --member=serviceAccount:clusterforge-platform@clusterforge-shared.iam.gserviceaccount.com \
  --role=roles/compute.admin

gcloud projects add-iam-policy-binding clusterforge-dev \
  --member=serviceAccount:clusterforge-platform@clusterforge-dev.iam.gserviceaccount.com \
  --role=roles/compute.admin
```

### 4. Deploy Landing Zone Network

Create the hub-and-spoke network structure in each project:

```bash
# For each project, deploy the landing-zone-network module
cd blueprints/landing-zone
tofu apply -var project_id=clusterforge-shared
```

### 5. Deploy GKE Clusters

Create Kubernetes clusters in spoke projects:

```bash
# Use modules/gke to deploy clusters
```

## Customization

### Changing Project Names

Edit `terraform.tfvars`:

```hcl
shared_project_name = "My Company Shared Services"
dev_project_name    = "My Company Development"
prod_project_name   = "My Company Production"
sandbox_project_name = "My Company Sandbox"
```

### Using Different Project IDs

Project IDs are globally unique. If defaults are taken:

```hcl
shared_project_id = "mycompany-shared"
dev_project_id    = "mycompany-dev"
prod_project_id   = "mycompany-prod"
sandbox_project_id = "mycompany-sandbox"
```

### Adding Custom Labels

Organize projects by team or cost center:

```hcl
additional_labels = {
  team         = "platform-engineering"
  cost-center  = "10001"
  compliance   = "sox"
  owner        = "john@example.com"
}
```

### Creating in a Folder

Organize under a GCP folder:

```bash
# List folders
gcloud resource-manager folders list --organization=123456789012

# Use folder ID in terraform.tfvars
folder_id = "123456789012"
```

### Enabling Platform Service Accounts

For cross-project operations:

```hcl
create_platform_service_accounts = true
```

Then grant necessary roles to these accounts.

## Troubleshooting

### Project ID Already Exists

**Error:** `Error: googleapi: Error 409: Requested entity already exists`

**Solution:** Project IDs are globally unique. Use different IDs or import existing projects:

```bash
tofu import google_project.main clusterforge-shared
```

### Billing Account Not Found

**Error:** `Error: Error setting billing account: googleapi: Error 404`

**Solution:**
1. Verify billing account ID: `gcloud billing accounts list`
2. Ensure your account has billing permissions
3. Use the alphanumeric ID only (without `billingAccounts/` prefix)

### Permission Denied for Project Creation

**Error:** `Error: Error creating Project: googleapi: Error 403: Permission denied`

**Solution:**
1. Verify you have `roles/resourcemanager.projectCreator`
2. If using a service account, ensure it has the required roles
3. Check organization policies aren't blocking project creation

### Service Enablement Fails

**Error:** `Error: Error enabling service: googleapi: Error 403: User not authorized to enable service`

**Solution:**
1. Verify you have `roles/serviceusage.serviceUsageAdmin`
2. Some services have dependencies and may take time to enable
3. Try applying again after a few minutes

## State Management

### Local State (Development)

By default, state is stored locally:

```bash
ls -la terraform.tfstate*
```

### Remote State (Production)

For production, use remote state:

```hcl
# Create a backend.tf file:
terraform {
  backend "gcs" {
    bucket = "my-terraform-state-bucket"
    prefix = "clusterforge/projects"
  }
}
```

Then initialize:

```bash
tofu init -migrate-state
```

## Cleanup

To remove all projects:

```bash
# Review what will be destroyed
tofu plan -destroy

# Destroy projects
tofu destroy
```

**Note:** The module includes `prevent_destroy = true` to prevent accidental deletion. You must override this in main.tf first.

## Cost Estimation

- Project creation: Free
- Service enablement: Free (costs depend on usage)
- Service accounts: Free
- Actual services: Billed based on usage

Expected monthly costs depend on:
- GKE cluster sizing
- Compute Engine instance count
- Storage usage
- Data transfer

## Multi-Project Architecture

This blueprint creates a landing zone supporting:

```
┌─────────────────────────────────────┐
│      clusterforge-shared (Hub)      │
│  ├─ Shared Services                 │
│  ├─ Central Monitoring              │
│  ├─ Artifact Registry               │
│  └─ Secret Management               │
└─────────────────────────────────────┘
        ↓   ↓   ↓
   ┌────┴───┴───┴────┐
   ↓                 ↓
┌──────────┐    ┌──────────┐
│    Dev   │    │   Prod   │
├──────────┤    ├──────────┤
│ GKE Dev  │    │ GKE Prod │
│ App Dev  │    │ App Prod │
└──────────┘    └──────────┘
   ↓
┌──────────┐
│ Sandbox  │
├──────────┤
│ GKE Test │
│ Exp.     │
└──────────┘
```

## Related Modules & Blueprints

- `modules/project-factory`: Core project creation module
- `modules/landing-zone-network`: Hub-and-spoke network setup
- `modules/gke`: GKE cluster deployment
- `blueprints/landing-zone`: Network setup for individual projects

## Support & Documentation

For detailed information:
- See [modules/project-factory/README.md](../../modules/project-factory/README.md)
- Review [Google Cloud documentation](https://cloud.google.com/docs)
- Check GCP project quotas and limits

## License

This blueprint is part of ClusterForge and follows the repository's license terms.
