# ClusterForge Landing Zone v2

This document defines the enterprise Google Cloud Platform (GCP) landing zone architecture for ClusterForge using a Hub-and-Spoke model. It is written for platform engineering teams and describes the recommended project structure, network design, security posture, and operational strategy for enterprise-scale GKE adoption.

## 1. Architecture Overview

ClusterForge adopts a Hub-and-Spoke landing zone architecture to deliver enterprise-grade isolation, centralized platform services, and predictable network boundaries. The design separates shared platform capabilities from environment-specific workloads while preserving strong security, governance, and operational clarity.

Key principles:
- Logical separation of shared platform services and environment workloads
- Clear IAM boundaries per project
- Centralized networking and security controls in a shared hub
- Environment-specific GKE workloads in discrete spoke projects
- Scalable CIDR allocations to avoid address overlap and enable future expansion

## 2. GCP Project Strategy

ClusterForge uses a multi-project GCP strategy aligned with enterprise landing zone best practices. Each project has a distinct operational purpose and scope.

Project topology:
- `clusterforge-shared`
- `clusterforge-dev`
- `clusterforge-prod`
- `clusterforge-sandbox`

This structure supports:
- environment-specific isolation
- cost and compliance visibility
- separate audit trails and IAM policies
- reduced blast radius for deployment and access changes

## 3. Shared Services Project

The `clusterforge-shared` project is the hub of the landing zone.

Responsibilities:
- centralized platform services and shared infrastructure
- OpenTofu/Terraform state backend
- Artifact Registry for container images
- central logging / monitoring sink
- DNS and service discovery
- shared VPC hub network and firewall policy enforcement
- identity and access controls for platform operators

Design rationale:
- A dedicated shared services project removes platform dependencies from workload projects.
- Centralizing common services reduces duplication and improves governance.
- Shared networking services are easier to secure and monitor from one project.

## 4. Environment Projects

Each environment project is a spoke that hosts environment-specific resources and workloads.

### `clusterforge-dev`
Purpose:
- development clusters
- feature validation
- engineering sandboxing

### `clusterforge-prod`
Purpose:
- production applications
- customer-facing workloads
- resilient operations and compliance controls

### `clusterforge-sandbox`
Purpose:
- proof-of-concept work
- learning and experimentation
- temporary or non-critical workloads

Design rationale:
- Environment projects limit scope for IAM, billing, and policy enforcement.
- Segregating non-production workloads from production supports safer change control.
- Sandbox can be aggressively permissive without affecting core environments.

## 5. Hub-and-Spoke Networking

The landing zone uses a hub network in the shared project connected to spoke networks in each environment project.

Architecture:
- Hub VPC in `clusterforge-shared`
- Spoke VPC in `clusterforge-dev`, `clusterforge-prod`, and `clusterforge-sandbox`
- VPC peering or Shared VPC attachments between hub and spokes
- Centralized service appliances, firewalls, and DNS hosted in the hub

Design decisions:
- The hub centralizes east-west connectivity for shared services and security tooling.
- Spokes retain isolation while still reaching shared platform infrastructure.
- The model supports growth to additional environments, partner workloads, or cross-region expansion.

## 6. CIDR Allocation Strategy

CIDR allocations are fixed and non-overlapping to simplify routing, firewall rules, and future expansion.

Assigned ranges:
- Shared: `10.0.0.0/16`
- Dev: `10.10.0.0/16`
- Prod: `10.20.0.0/16`
- Sandbox: `10.30.0.0/16`

Rationale:
- Using /16 blocks per project provides ample address space for subnet segmentation and future service expansion.
- Non-overlapping ranges prevent peering and routing conflicts.
- A disciplined allocation plan supports predictable network operations and observability.

## 7. GKE Network Design

GKE clusters are deployed with private network controls and strong isolation between cluster pods, services, and the wider VPC.

Core design:
- regional GKE clusters for high availability
- private nodes and private endpoint configuration where appropriate
- VPC-native networking with alias IP ranges
- Kubernetes network policy enabled by default
- separate subnets for control plane, node pools, and auxiliary services

Design rationale:
- Private clusters reduce public attack surface for workloads.
- Alias IP ranges provide native, cloud-managed pod and service IP allocation.
- Network policy enforces east-west segmentation at the cluster level.
- Regionally scoped clusters support resiliency while staying operationally manageable.

## 8. Workload Identity Strategy

ClusterForge uses GKE Workload Identity as the standard credential model for cloud access.

Strategy:
- bind Kubernetes Service Accounts to Google Service Accounts
- assign least privilege IAM roles to each Google Service Account
- avoid long-lived service account keys inside clusters
- configure workload identity namespaces per environment/project

Rationale:
- Workload Identity eliminates static secrets, improving security posture.
- It enables fine-grained access control and auditability for cloud resource access.
- Native GCP integration simplifies cloud operations and compliance.

## 9. Traffic Flow Design

Traffic flow is designed to preserve isolation while enabling secure access to shared services and external endpoints.

Inbound flow:
- external traffic terminates at managed ingress in the spoke cluster or shared edge services
- public ingress may route through centralized DNS and certificates managed by the shared project

East-west flow:
- workload traffic between spoke clusters and shared services traverses the hub network
- communication is restricted by firewall rules and service perimeter policies
- cross-environment access is limited to explicit, documented use cases

Outbound flow:
- cluster workloads egress through controlled NAT or proxy services
- access to Google APIs uses private service access where possible
- external dependencies are constrained by allowlists and monitoring

Design rationale:
- Explicit ingress and egress paths reduce unintended access and simplify incident response.
- Centralizing shared traffic controls in the hub allows unified security enforcement.
- Restricting east-west cross-spoke traffic reduces lateral movement risk.

## 10. Platform Add-ons Strategy

Platform add-ons are installed consistently across clusters using an opinionated standard stack.

Core add-ons:
- ArgoCD for GitOps delivery management
- NGINX or managed ingress controller for external traffic
- cert-manager for TLS lifecycle automation
- external-dns for domain automation
- metrics-server for Kubernetes telemetry

Deployment approach:
- provision add-ons as part of the platform bootstrap in each environment
- manage add-on configuration centrally through GitOps repositories
- keep add-on lifecycle separate from application delivery

Rationale:
- A consistent add-on baseline reduces drift and operational complexity.
- Platform-managed add-ons accelerate cluster onboarding and day-two operations.
- Centralized GitOps control ensures visibility and repeatability.

## 11. Secret Management Strategy

ClusterForge uses centralized secret storage with dynamic retrieval for workloads.

Strategy:
- store sensitive values in Google Secret Manager
- use External Secrets Operator or equivalent GitOps-friendly secret sync mechanism
- avoid embedding secrets in Git or Kubernetes manifests
- enable secret versioning and rotation policies

Rationale:
- Centralized secret storage delivers stronger access controls and audit trails.
- Managed secret injection reduces secret sprawl inside clusters.
- It enables platform teams to apply consistent rotation and lifecycle policies.

## 12. GitOps Strategy

GitOps is the primary deployment model for infrastructure, cluster configuration, and application delivery.

Principles:
- infrastructure and platform state are defined declaratively in Git
- `clusterforge-shared` and environment projects are managed through separate repositories or branches as needed
- ArgoCD or equivalent tooling continuously reconciles declared state to actual state
- pull request-based change control is used for all infrastructure and application updates

Rationale:
- GitOps provides auditability and traceability for platform changes.
- It enables automated drift detection and rollback.
- Change control is enforced through code review and repository policies.

## 13. Future Multi-Region Expansion

The architecture is designed to extend into multiple regions without changing the core project model.

Expansion considerations:
- create additional regional spoke networks with new CIDR blocks within the same project range plan
- deploy regional GKE clusters in additional regions for resilience
- retain the shared hub project as the central platform anchor
- ensure network topology and firewall policy support multi-region peering or Shared VPC attachments

Rationale:
- A regionally aware landing zone enables higher availability and disaster recovery.
- Maintaining the same project structure preserves governance and operational consistency.
- Planning CIDR allocations up front avoids address collisions as regions are added.

---

This landing zone model provides an enterprise-grade foundation for ClusterForge by combining strong project isolation, centralized shared services, and a scalable Hub-and-Spoke networking approach. It supports secure GKE delivery, consistent platform operations, and future expansion into additional environments and regions.