output "argocd_namespace" {
  value = length(kubernetes_namespace.argocd) > 0 ? kubernetes_namespace.argocd[0].metadata[0].name : null
}

output "istio_namespace" {
  value = length(kubernetes_namespace.istio) > 0 ? kubernetes_namespace.istio[0].metadata[0].name : null
}

output "cert_manager_namespace" {
  value = length(kubernetes_namespace.cert_manager) > 0 ? kubernetes_namespace.cert_manager[0].metadata[0].name : null
}
