# Environment Strategy

Environment architecture
- Each environment (`dev`, `prod`, `sandbox`) is a thin configuration layer that consumes the reusable `blueprints/standard-gke` blueprint.
- All infrastructure code (modules & blueprint) lives under `modules/` and `blueprints/` and is not duplicated in environments.

Dev strategy
- Lightweight configuration for rapid iteration. Single-node initial pool, no deletion protection.

Prod strategy
- Production settings: larger initial node count, higher autoscaling ceilings, and `deletion_protection = true` to reduce accidental removals.

Sandbox strategy
- Small, low-cost configuration for experiments. Lower machine class and conservative autoscaling.

Promotion model
- Promote configuration values manually from `sandbox` -> `dev` -> `prod` or via automated CI that applies environment-specific `terraform.tfvars` in each folder.
- The blueprint and modules remain constant during promotion to ensure consistent infrastructure.

Future multi-region support
- Add a `region` or `locations` map per environment and parameterize the blueprint to accept multi-region inputs. Keep the environment layer as configuration only.
