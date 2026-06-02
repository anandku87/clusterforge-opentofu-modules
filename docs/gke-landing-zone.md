1. GCP Project Strategy
## GCP Project Strategy

ClusterForge will follow a multi-project architecture aligned with enterprise landing zone practices.

### Project Model

Organization
│
├── Shared Services Project
│    ├── OpenTofu State
│    ├── Artifact Registry
│    ├── Central Logging
│    └── DNS Services
│
├── clusterforge-dev
├── clusterforge-prod
└── clusterforge-sandbox

### Shared Services Project Responsibilities

The shared services project hosts platform-wide services including:

- Terraform/OpenTofu state storage
- Container image repositories
- Centralized logging
- Monitoring services
- DNS management
- Shared networking services

### Environment Projects

Each environment receives its own dedicated GCP project:

#### clusterforge-dev
Purpose:
- Development clusters
- Feature testing
- Engineering experimentation

#### clusterforge-prod
Purpose:
- Production workloads
- Customer-facing environments

#### clusterforge-sandbox
Purpose:
- Proof of concepts
- Training environments
- Temporary workloads

### Benefits

- Strong environment isolation
- Separate IAM boundaries
- Cost visibility per environment
- Easier compliance and governance
- Simplified future multi-cluster strategy

2. Workload Identity Strategy

## Workload Identity Strategy

ClusterForge will use GKE Workload Identity for all workloads.

### Architecture

Kubernetes Service Account
        ↓
Workload Identity
        ↓
Google Service Account
        ↓
Google Cloud Resources

### Design Principles

- No long-lived cloud credentials inside containers
- No service account keys stored in Kubernetes
- Least privilege access model
- Workload-specific permissions

### Benefits

- Improved security
- Simplified credential management
- Native GCP integration
- Auditability

3. Platform Add-ons Strategy

## Platform Add-ons Strategy

Every ClusterForge-managed cluster should be provisioned with a standard platform stack.

### Core Add-ons

#### ArgoCD
Purpose:
- GitOps deployment management

#### NGINX Ingress Controller
Purpose:
- External traffic ingress

#### Cert Manager
Purpose:
- TLS certificate automation

#### External DNS
Purpose:
- Automated DNS management

#### Metrics Server
Purpose:
- Kubernetes metrics collection

### Future Add-ons

- Prometheus
- Grafana
- Loki
- Kyverno
- Falco
- Service Mesh

4. Secret Management Strategy

## Secret Management Strategy

ClusterForge will avoid storing application secrets directly inside Kubernetes whenever possible.

### Architecture

Application
      ↓
External Secrets Operator
      ↓
Google Secret Manager

### Design Principles

- Centralized secret storage
- Secret rotation support
- Reduced secret sprawl
- Cloud-native integration

### Future Enhancements

- HashiCorp Vault integration
- Multi-cloud secret abstraction

5. Standard Cluster Blueprint

## Standard Cluster Blueprint v1

This blueprint represents the default ClusterForge cluster profile.

### Cluster Configuration

Cluster Type:
- Regional GKE Cluster

Control Plane:
- Google Managed

Workload Identity:
- Enabled

Network Policy:
- Enabled

Private Nodes:
- Enabled

### Node Pool

Node Pools

system-pool
- Kubernetes system workloads
- ArgoCD
- Ingress
- Monitoring

application-pool
- Customer applications
- Business workloads

Machine Type:
- e2-standard-4

Autoscaling:
- Enabled

Minimum Nodes:
- 1

Maximum Nodes:
- 3

Disk Size:
- 100 GB

Disk Type:
- Balanced Persistent Disk

### Add-ons

- Metrics Server
- ArgoCD
- NGINX Ingress
- Cert Manager

6. OpenTofu State Management Strategy

## OpenTofu State Management Strategy

ClusterForge will use a centralized remote backend for OpenTofu state management.

### Backend

Google Cloud Storage (GCS)

### State Bucket

clusterforge-tf-state

### Design Principles

- Remote state storage
- Team collaboration support
- State durability
- Disaster recovery readiness

### State Structure

clusterforge-tf-state/

dev/
  network/
  gke/

prod/
  network/
  gke/

sandbox/
  network/
  gke/

### Future Enhancements

- State locking
- Encryption using CMEK
- Multi-region bucket replication


## Environment Promotion Strategy

ClusterForge follows an environment promotion model.

Development
    ↓
Sandbox Validation
    ↓
Production

Purpose:
- Validate infrastructure changes before production rollout
- Reduce deployment risk
- Support GitOps workflows

## Security Baseline

The following controls are enabled by default:

- Workload Identity
- Private Nodes
- Network Policies
- Shielded Nodes
- Binary Authorization (future)
- Pod Security Standards
- Secret Manager integration
- Least Privilege IAM

Future Enhancements:
- Policy Controller
- Kyverno
- Gatekeeper
- Runtime Threat Detection