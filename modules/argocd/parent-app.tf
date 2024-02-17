# This is here to fix a bug where terraform tries to get hashicorp/kubectl instead of gavinbunney
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.11.3"
    }
  }
}


# resource "kubectl_manifest" "parent_app" {
#   depends_on = [
#     helm_release.argocd,
#     kubernetes_secret.argocd_ssh_key
#   ]

#    manifest = file("${path.module}/templates/parent-app.yaml")
# }

