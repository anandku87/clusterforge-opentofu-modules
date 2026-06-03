# GKE Module

Purpose
- Reusable OpenTofu module to create a regional Google Kubernetes Engine (GKE) cluster with a configurable node pool.

Architecture Overview
- Regional, VPC-native GKE cluster using IP aliasing for pods & services via existing secondary ranges.
- Cluster is created with Workload Identity, Network Policy, Shielded Nodes, and a dedicated node pool.

Features Implemented
- Workload Identity: enabled via `workload_identity_config` and uses the project's workload pool.
- Network Policy: VPC-native network policy enabled for pod-level network controls.
- Shielded Nodes: node-level protections enabled for increased security.
- Autoscaling: node pool autoscaling configured (min/max) and cluster-level autoscaling placeholder added (disabled by default).
- Deletion Protection: optional cluster deletion protection supported via `deletion_protection` variable.

Workload Identity
- The module configures `workload_identity_config` to use the project's workload pool (`<project>.svc.id.goog`).

Network Policy
- `network_policy.enabled = true` is set to enforce network-level isolation.

Shielded Nodes
- Shielded nodes and shielded instance config (secure boot and integrity monitoring) are enabled for nodes.

Autoscaling
- Node pool-level autoscaling is enabled via `autoscaling` with `min_node_count` and `max_node_count`.
- A cluster-level `cluster_autoscaling` block is present as a placeholder and set to `enabled = false`.

Deletion Protection
- The module exposes `deletion_protection` (bool) to protect the cluster resource from accidental deletion.

Inputs
- `project_id` (string) - GCP project where the cluster will be created.
- `cluster_name` (string) - Name of the GKE cluster.
- `region` (string) - GCP region for the cluster (regional cluster).
- `network` (string) - Existing VPC name.
- `subnetwork` (string) - Existing subnetwork name.
- `pods_range_name` (string) - Pods secondary range name.
- `services_range_name` (string) - Services secondary range name.
- `machine_type` (string) - Node machine type.
- `node_count` (number) - Initial node count for the node pool.
- `min_nodes` (number) - Minimum nodes for autoscaling.
- `max_nodes` (number) - Maximum nodes for autoscaling.
- `disk_size` (number) - Boot disk size (GB) for nodes.
- `disk_type` (string) - Boot disk type (`pd-standard` or `pd-ssd`).
- `deletion_protection` (bool) - Protect the cluster from accidental deletion (default: false).

Outputs
- `cluster_name` - The created cluster name.
- `cluster_endpoint` - Cluster endpoint (API server address).
- `cluster_ca_certificate` - Cluster CA certificate (base64 encoded by provider).
- `cluster_id` - Resource id of the cluster.

Example Usage
```
module "gke" {
  source = "../../modules/gke"

  project_id   = "clusterforge-dev"
  cluster_name = "clusterforge-dev"
  region       = "asia-south1"

  network = module.network.vpc_name
  subnetwork = module.network.subnet_name

  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name

  machine_type = "e2-standard-4"

  node_count = 1
  min_nodes  = 1
  max_nodes  = 3

  disk_size = 100

  deletion_protection = false
}
```

Example Usage
```
module "gke" {
  source = "../../modules/gke"

  project_id   = "clusterforge-dev"
  cluster_name = "clusterforge-dev"
  region       = "asia-south1"

  network = module.network.vpc_name
  subnetwork = module.network.subnet_name

  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name

  machine_type = "e2-standard-4"

  node_count = 1
  min_nodes  = 1
  max_nodes  = 3

  disk_size = 100
}
```

Future Enhancements
- Support multiple node pools and taints/labels for workloads.
- Add options for private clusters and master authorized networks.
- Add optional node auto-provisioning and node auto-upgrade channels selection.
- Export kubeconfig generation helper or a `kubeconfig` output.
