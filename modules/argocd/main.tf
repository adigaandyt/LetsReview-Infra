terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.11.3"
    }
  }
}


# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     name = "argocd"
#   }
# }

# Helm Chart for ArgoCD to install on Cluster
# TODO: Host chart on the repo
resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.53.13" # Specify the version you want to use

  # Pass helm chart values
  values = [
    "${file(var.argocd_values_filepath)}"
  ]

  # Wait for namespace, SSH for Gitops Repo
  depends_on = [
    kubernetes_secret.argocd_ssh_key 
  ]
}

# Pass application resource to point to GitOps repo
resource "kubectl_manifest" "bootstrap_application" {
  depends_on = [helm_release.argocd]

  yaml_body = file(var.bootstrap_application_path)
}