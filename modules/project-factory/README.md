# Project Factory Module

A reusable OpenTofu module that provisions and manages GCP projects for ClusterForge.

## Overview

This module simplifies and standardizes the creation of GCP projects within the ClusterForge platform. It automates:

- GCP project creation with standardized naming and labeling
- Automatic enabling of required Google Cloud services
- Default label application (platform, managed_by, environment)
- Optional platform service account creation
- Consistent configuration across development, staging, production, and sandbox environments

## Architecture

The module is designed to be used to create ClusterForge's multi-project landing zone:

```
Organization / Folder
├── clusterforge-shared (Hub Project)
├── clusterforge-dev (Dev Spoke Project)
├── clusterforge-prod (Prod Spoke Project)
└── clusterforge-sandbox (Sandbox Spoke Project)
```

Each project created by this module:
- Receives standard platform labels
- Has required APIs automatically enabled
- Optionally creates a platform service account
- Can be organized under a specific folder

## Prerequisites

- OpenTofu >= 1.8.0
- Google Cloud Provider >= 5.0
- A valid GCP billing account
- Appropriate IAM permissions (Project Creator, Service Usage Admin)
- GCP organization setup (optional, for folder_id)

## Usage

### Basic Example: Create a Single Project

```hcl
module "shared_project" {
  source = "../../modules/project-factory"

  project_id       = "clusterforge-shared"
  project_name     = "ClusterForge Shared Services"
  billing_account  = "01AB23-CD45EF-G6HI90"
  environment      = "shared"
}
```

### Create Multiple Projects

```hcl
module "dev_project" {
  source = "../../modules/project-factory"

  project_id       = "clusterforge-dev"
  project_name     = "ClusterForge Development"
  billing_account  = "01AB23-CD45EF-G6HI90"
  environment      = "dev"
}

module "prod_project" {
  source = "../../modules/project-factory"

  project_id       = "clusterforge-prod"
  project_name     = "ClusterForge Production"
  billing_account  = "01AB23-CD45EF-G6HI90"
  environment      = "prod"
}

module "sandbox_project" {
  source = "../../modules/project-factory"

  project_id       = "clusterforge-sandbox"
  project_name     = "ClusterForge Sandbox"
  billing_account  = "01AB23-CD45EF-G6HI90"
  environment      = "sandbox"
}
```

### Create Project Under a Folder

```hcl
module "dev_project_in_folder" {
  source = "../../modules/project-factory"

  project_id       = "clusterforge-dev"
  project_name     = "ClusterForge Development"
  billing_account  = "01AB23-CD45EF-G6HI90"
  environment      = "dev"
  folder_id        = "123456789012"  # Numeric folder ID
}
```

### Create Project with Additional Labels and Platform Service Account

```hcl
module "prod_project_with_sa" {
  source = "../../modules/project-factory"

  project_id       = "clusterforge-prod"
  project_name     = "ClusterForge Production"
  billing_account  = "01AB23-CD45EF-G6HI90"
  environment      = "prod"

  additional_labels = {
    team    = "platform"
    cost-center = "engineering"
    compliance = "pci-dss"
  }

  create_platform_service_account = true
}
```

### Custom Service Enablement

```hcl
module "custom_project" {
  source = "../../modules/project-factory"

  project_id       = "clusterforge-custom"
  project_name     = "ClusterForge Custom"
  billing_account  = "01AB23-CD45EF-G6HI90"
  environment      = "dev"

  enabled_services = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudkms.googleapis.com",           # Additional service
    "container-registry.googleapis.com", # Additional service
  ]
}
```

## Variables

### Required Variables

#### `project_id`
- **Type:** `string`
- **Description:** The unique project ID. Must be 6-30 lowercase letters, digits, or hyphens. Must start with a letter.
- **Example:** `"clusterforge-prod"`
- **Validation:** Enforced by module

#### `project_name`
- **Type:** `string`
- **Description:** The display name of the project
- **Example:** `"ClusterForge Production"`

#### `billing_account`
- **Type:** `string`
- **Description:** The alphanumeric ID of the billing account this project belongs to. The user or service account performing this operation must have the Billing Project Manager or Billing Account Administrator role.
- **Example:** `"01AB23-CD45EF-G6HI90"`

### Optional Variables

#### `folder_id`
- **Type:** `string`
- **Default:** `null`
- **Description:** The numeric ID of the folder this project should be created under. If not supplied, the project is created under the organization root.
- **Example:** `"123456789012"`

#### `environment`
- **Type:** `string`
- **Default:** `"development"`
- **Description:** The environment label for the project
- **Valid Values:** `development`, `production`, `sandbox`, `shared`, `dev`, `prod`
- **Example:** `"prod"`

#### `additional_labels`
- **Type:** `map(string)`
- **Default:** `{}`
- **Description:** Additional labels to apply to the project. These are merged with default labels.
- **Example:**
  ```hcl
  {
    team         = "platform"
    cost-center  = "engineering"
    compliance   = "pci-dss"
  }
  ```

#### `enabled_services`
- **Type:** `list(string)`
- **Default:** See Default Services section below
- **Description:** List of Google Cloud services to enable. Default includes essential ClusterForge services.
- **Example:**
  ```hcl
  [
    "compute.googleapis.com",
    "container.googleapis.com",
    "cloudkms.googleapis.com",
  ]
  ```

#### `create_platform_service_account`
- **Type:** `bool`
- **Default:** `false`
- **Description:** Whether to create the clusterforge-platform service account
- **Example:** `true`

## Default Services

The module enables these Google Cloud services by default:

| Service | Purpose |
|---------|---------|
| `compute.googleapis.com` | Compute Engine (VMs, networks) |
| `container.googleapis.com` | Google Kubernetes Engine (GKE) |
| `artifactregistry.googleapis.com` | Artifact Registry (container images) |
| `secretmanager.googleapis.com` | Secret Manager (secrets storage) |
| `iam.googleapis.com` | Identity and Access Management |
| `cloudresourcemanager.googleapis.com` | Cloud Resource Manager |
| `servicenetworking.googleapis.com` | Service Networking (VPC peering) |
| `monitoring.googleapis.com` | Cloud Monitoring |
| `logging.googleapis.com` | Cloud Logging |

Additional services can be enabled by passing a custom `enabled_services` list.

## Default Labels

The module automatically applies these labels to all projects:

| Label | Value | Purpose |
|-------|-------|---------|
| `platform` | `clusterforge` | Identifies as part of ClusterForge |
| `managed_by` | `opentofu` | Indicates infrastructure-as-code management |
| `environment` | User-supplied | dev, prod, sandbox, shared, etc. |

Additional labels can be supplied via `additional_labels` and are merged with defaults.

## Outputs

### Primary Outputs

#### `project_id`
- **Type:** `string`
- **Description:** The GCP project ID
- **Example:** `"clusterforge-prod"`

#### `project_number`
- **Type:** `number`
- **Description:** The GCP project number (unique numeric identifier)
- **Example:** `123456789012`

#### `project_name`
- **Type:** `string`
- **Description:** The display name of the GCP project
- **Example:** `"ClusterForge Production"`

#### `billing_account`
- **Type:** `string`
- **Description:** The billing account associated with the project
- **Example:** `"01AB23-CD45EF-G6HI90"`

#### `enabled_services`
- **Type:** `list(string)`
- **Description:** List of Google Cloud services that have been enabled

#### `project_labels`
- **Type:** `map(string)`
- **Description:** Labels applied to the project (defaults + additional)
- **Example:**
  ```
  {
    environment = "prod"
    managed_by = "opentofu"
    platform = "clusterforge"
  }
  ```

#### `folder_id`
- **Type:** `string`
- **Description:** The folder ID where the project is located

### Conditional Outputs (when `create_platform_service_account = true`)

#### `service_account_email`
- **Type:** `string`
- **Description:** Email address of the platform service account
- **Example:** `"clusterforge-platform@clusterforge-prod.iam.gserviceaccount.com"`

#### `service_account_id`
- **Type:** `string`
- **Description:** Unique ID of the platform service account
- **Example:** `"123456789012345"`

## Service Account

When `create_platform_service_account` is set to `true`, the module creates a service account with:

- **Account ID:** `clusterforge-platform`
- **Display Name:** "ClusterForge Platform Service Account"
- **Project:** The created project
- **Email:** `clusterforge-platform@<project-id>.iam.gserviceaccount.com`

The service account is created without any IAM roles attached. Assign roles using the `google_project_iam_member` resource or equivalent.

### Example: Granting Roles to Service Account

```hcl
resource "google_project_iam_member" "platform_sa_compute_admin" {
  project = module.dev_project.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${module.dev_project.service_account_email}"
}
```

## Lifecycle Management

### Project Protection

The module includes a lifecycle rule to prevent accidental project destruction:

```hcl
lifecycle {
  prevent_destroy = true
}
```

To destroy a project, you must:
1. Remove the `prevent_destroy` rule
2. Run `tofu destroy`

Or manually delete the project through the GCP console.

### Service Disablement

By default, disabling a service in `enabled_services` will NOT disable the service in GCP:

```hcl
disable_on_destroy = false
```

This prevents accidental service disruption. To enable disabling on destruction, modify `main.tf`:

```hcl
disable_on_destroy = true
```

## Accessing Billing Account ID

To find your billing account ID:

```bash
gcloud billing accounts list --format="value(name)"
```

Output format: `billingAccounts/01AB23-CD45EF-G6HI90`

Use only the alphanumeric part: `01AB23-CD45EF-G6HI90`

## Finding Folder IDs

To list folders in your organization:

```bash
gcloud resource-manager folders list --organization=YOUR_ORG_ID
```

## Accessing Project Number

The project number is returned as `output.project_number`:

```bash
tofu output project_number
```

Or use in dependent modules:

```hcl
resource "google_compute_network" "main" {
  name    = "vpc-main"
  project = module.dev_project.project_id
}
```

## Validation

The module includes input validation:

- **Project ID:** Must be 6-30 characters, alphanumeric with hyphens, start with a letter
- **Environment:** Must be one of the predefined valid values

Invalid inputs will cause Terraform/OpenTofu to fail with a descriptive error message.

## Multi-Project Blueprint

For a complete example of creating all ClusterForge projects, see the blueprint at:
`blueprints/clusterforge-projects/`

## Troubleshooting

### Project ID Already Exists

**Error:** `Error: googleapi: Error 409: Requested entity already exists, alreadyExists`

**Solution:** The project ID is globally unique across all GCP. Use a unique project ID or recover the existing project:

```bash
gcloud config set project <existing-project-id>
tofu import google_project.main <existing-project-id>
```

### Billing Account Not Found

**Error:** `Error: Error setting billing account: googleapi: Error 404: Billing account not found, notFound`

**Solution:**
1. Verify the billing account ID is correct
2. Ensure your service account has billing permissions
3. Confirm the billing account exists: `gcloud billing accounts list`

### Service Enablement Timeout

**Error:** `Error: Error enabling service X: googleapi: Error 403: User not authorized to enable service X, forbidden`

**Solution:**
1. Verify your account has Service Usage Admin role on the project
2. Some services have dependencies and may take time to enable
3. Try reducing the list to only essential services

### Folder ID Invalid

**Error:** `Error: Error creating Project: googleapi: Error 400: Invalid folder ID, invalidArgument`

**Solution:**
1. Verify the folder exists: `gcloud resource-manager folders list`
2. Ensure the folder ID is numeric (not the display name)
3. Verify permissions to create projects in the folder

## Best Practices

1. **Project Naming:** Use consistent naming conventions (e.g., `clusterforge-<environment>`)
2. **Labels:** Use additional_labels for cost allocation and compliance tracking
3. **Service Accounts:** Create platform service accounts when deploying across projects
4. **Billing:** Ensure billing account has sufficient quota and budget alerts enabled
5. **Backup:** Regularly export project configurations as backup
6. **IAM:** Use separate modules to manage IAM bindings after project creation

## Cost Considerations

- Project creation is free
- Service enablement is free (costs depend on service usage)
- Service accounts are free
- Billed services: Compute Engine, GKE, Cloud Storage, etc. (based on usage)

## Related Modules

- `modules/landing-zone-network`: Creates the network infrastructure
- `modules/gke`: Deploys GKE clusters
- `modules/addons`: Installs platform add-ons

## Support & Contributions

For issues, questions, or improvements:
1. Review the troubleshooting section
2. Check GCP documentation for service-specific issues
3. Submit pull requests with improvements

## License

This module is part of ClusterForge and follows the repository's license terms.
