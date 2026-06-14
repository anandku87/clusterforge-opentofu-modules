resource "kubernetes_namespace" "argocd" {
  count = var.enable_argocd ? 1 : 0

  metadata {
    name = "argocd"
    labels = {
      app = "argocd"
    }
  }
}

resource "kubernetes_namespace" "istio" {
  count = var.enable_istio ? 1 : 0

  metadata {
    name = "istio-system"
    labels = {
      app = "istio"
    }
  }
}

resource "kubernetes_namespace" "cert_manager" {
  count = var.enable_cert_manager ? 1 : 0

  metadata {
    name = "cert-manager"
    labels = {
      app = "cert-manager"
    }
  }
}

resource "helm_release" "argocd" {
  count = var.enable_argocd ? 1 : 0

  name             = "argocd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = var.argocd_version
  namespace        = kubernetes_namespace.argocd[0].metadata[0].name
  create_namespace = false
}

resource "helm_release" "istio_base" {
  count = var.enable_istio ? 1 : 0

  name             = "istio-base"
  chart            = "base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  version          = var.istio_version
  namespace        = kubernetes_namespace.istio[0].metadata[0].name
  create_namespace = false
}

resource "helm_release" "istiod" {
  count = var.enable_istio ? 1 : 0

  name             = "istiod"
  chart            = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  version          = var.istio_version
  namespace        = kubernetes_namespace.istio[0].metadata[0].name
  create_namespace = false
  depends_on       = [helm_release.istio_base]
}

resource "helm_release" "istio_gateway" {
  count = var.enable_istio ? 1 : 0

  name             = "istio-gateway"
  chart            = "gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  version          = var.istio_version
  namespace        = kubernetes_namespace.istio[0].metadata[0].name
  create_namespace = false
  depends_on       = [helm_release.istio_base]
}

resource "helm_release" "cert_manager" {
  count = var.enable_cert_manager ? 1 : 0

  name             = "cert-manager"
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  version          = var.cert_manager_version
  namespace        = kubernetes_namespace.cert_manager[0].metadata[0].name
  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "metrics_server" {
  count = var.enable_metrics_server ? 1 : 0

  name             = "metrics-server"
  chart            = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  version          = var.metrics_server_version
  namespace        = "kube-system"
  create_namespace = false
}
