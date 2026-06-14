variable "enable_argocd" {
  description = "Enable installation of ArgoCD via Helm."
  type        = bool
  default     = true
}

variable "enable_istio" {
  description = "Enable installation of Istio Base, Istiod, and Istio Gateway via Helm."
  type        = bool
  default     = true
}

variable "enable_cert_manager" {
  description = "Enable installation of Cert Manager via Helm."
  type        = bool
  default     = true
}

variable "enable_metrics_server" {
  description = "Enable installation of Metrics Server via Helm."
  type        = bool
  default     = true
}

variable "argocd_version" {
  description = "Helm chart version for ArgoCD."
  type        = string
  default     = "9.5.9"
}

variable "istio_version" {
  description = "Helm chart version for Istio components."
  type        = string
  default     = "1.30.1"
}

variable "cert_manager_version" {
  description = "Helm chart version for Cert Manager."
  type        = string
  default     = "v1.9.2"
}

variable "metrics_server_version" {
  description = "Helm chart version for Metrics Server."
  type        = string
  default     = "3.9.0"
}
