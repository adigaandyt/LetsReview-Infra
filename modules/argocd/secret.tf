# Grab the SSH private key we uploaded manually
data "aws_secretsmanager_secret_version" "gitops-ssh-key" {
  secret_id = var.gitops_ssh_secret_arn  
}

# Create a kubernetes secret so our ArgoCD can grab it
resource "kubernetes_secret" "argocd_ssh_key" {
  metadata {
    name      = "argocd-ssh-key"
    namespace = "argocd"
  }

  # Use the key name to grab it's value
  data = {
    (var.gitops_ssh_key_name)  = data.aws_secretsmanager_secret_version.gitops-ssh-key.secret_string
  }

  type = "Opaque"
}