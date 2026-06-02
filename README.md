# ClusterForge OpenTofu Modules

ClusterForge is a Kubernetes Platform-as-a-Service foundation built with OpenTofu reusable infrastructure modules and GKE blueprints. This repository is designed to serve as the core platform engineering scaffold for an enterprise-grade Kubernetes delivery platform.

## Repository Purpose

This repository centralizes reusable OpenTofu modules, opinionated Google Kubernetes Engine (GKE) blueprints, and environment definitions for development, production, and sandbox deployments. It is intended to accelerate platform delivery by providing a modular, environment-aware structure that can be extended into a full platform engineering lifecycle.

## Recommended Folder Structure

- `modules/`
  - Reusable OpenTofu modules that encapsulate provider-agnostic and cloud-specific networking, security, and cluster resources.
  - `modules/gke/` - GKE-specific cluster constructs and lifecycle primitives.
  - `modules/network/` - VPC, subnet, firewall, and connectivity abstractions.
  - `modules/security/` - IAM, workload identity, security hardening, and policy integration.

- `blueprints/`
  - Opinionated cluster blueprints for standard and private GKE deployments.
  - `blueprints/standard-gke/` - Publicly accessible GKE blueprint with standard networking and shared services.
  - `blueprints/private-gke/` - Private GKE blueprint with isolated control plane and private node networking.

- `environments/`
  - Environment-specific definitions, variable sets, and deployment entrypoints.
  - `environments/dev/` - Development environment configuration.
  - `environments/prod/` - Production environment configuration.
  - `environments/sandbox/` - Sandbox environment for experimentation and isolated testing.

- `docs/`
  - Architecture guidance, platform design patterns, and day-two operational notes.
  - `docs/gke-landing-zone.md` - GKE landing zone design guidance for ClusterForge.

## Architecture Overview

ClusterForge is designed around a clean separation of concerns:

- **Modules** provide reusable infrastructure building blocks.
- **Blueprints** assemble those building blocks into platform opinionated delivery patterns.
- **Environments** provide deployment-specific input values, lifecycle organization, and operational context.
- **Documentation** captures platform design decisions and landing zone architecture.

This structure enables consistent deployments, easy reuse of modules, and separation between platform engineering authoring and environment-specific operational execution.

## Module Strategy

The module strategy is intentionally modular and extensible:

- Keep modules small and focused, with a single responsibility.
- Encapsulate GKE cluster constructs, network topology, and security controls separately.
- Reuse modules across blueprints to reduce drift and accelerate maintenance.
- Provide environment-specific wiring through `environments/*` rather than embedding environment logic inside modules.

Future modules can include cluster add-ons, IAM/identity bridging, observability, and policy frameworks.

## Future Roadmap

Planned next steps for ClusterForge:

1. Create concrete module implementations under `modules/gke`, `modules/network`, and `modules/security`.
2. Add blueprint composition and examples for both standard and private GKE deployment patterns.
3. Define environment input files and example OpenTofu workspaces for `dev`, `prod`, and `sandbox`.
4. Expand docs with security hardening, governance, observability, and upgrade strategies.
5. Add CI/CD integration, drift detection, and automated validation for platform changes.

## Getting Started

1. Review `docs/gke-landing-zone.md` to understand the proposed landing zone design.
2. Author and validate reusable modules inside `modules/`.
3. Assemble target delivery patterns in `blueprints/`.
4. Wire environment-specific values in `environments/`.

This repository is the starting point for a robust, enterprise-ready Kubernetes platform built with OpenTofu.
