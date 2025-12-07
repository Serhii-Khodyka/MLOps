resource "kubernetes_namespace" "infra_tools" {
  metadata {
    name = "infra-tools"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.infra_tools.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.14"

  values = [
    file("${path.module}/values/argocd-values.yaml")
  ]
}

output "argocd_namespace" {
  value = kubernetes_namespace.infra_tools.metadata[0].name
}