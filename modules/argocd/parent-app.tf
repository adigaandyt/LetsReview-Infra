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
    finalizers:
    - resources-finalizer.argocd.argoproj.io
  spec:
    project: default
    source:
      repoURL: "git@github.com:adigaandyt/ourlibrary_gitops.git"
      path: "infra-apps"
      targetRevision: HEAD
    destination:
      server: "https://kubernetes.default.svc"
      namespace: default
      createNamespace: true
    # sshPrivateKeySecret:
    #   name: private-repo-secret  # Name of the secret containing the SSH private key
    #   key: sshPrivateKey
    syncPolicy:
      automated:
        prune: true # or false, depending on your needs
        selfHeal: true # or false, based on preference
        
  YAML
}

