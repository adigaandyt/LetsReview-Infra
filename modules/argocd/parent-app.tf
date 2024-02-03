# This is here to fix a bug where terraform tries to get hashicorp/kubectl instead of gavinbunney
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.11.3"
    }
  }
}


resource "kubectl_manifest" "parent_app" {
  depends_on = [
    helm_release.argocd,
    kubernetes_secret.argocd_ssh_key
  ]
  
  yaml_body = <<-YAML
  apiVersion: argoproj.io/v1alpha1
  kind: Application
  metadata:
    name: parent-app
    namespace: argocd
  spec:
    project: default
    source:
      repoURL: "git@github.com:adigaandyt/ourlibrary_gitops.git"
      path: "infra-apps"
      targetRevision: "HEAD"
      sshPrivateKeySecret: "${var.ssh_private_key}"
    destination:
      server: "https://kubernetes.default.svc"
      namespace: "default"
    syncPolicy:
      automated:
        selfHeal: true
        prune: true
      syncOptions:
        - "CreateNamespace=true"
  YAML
}
