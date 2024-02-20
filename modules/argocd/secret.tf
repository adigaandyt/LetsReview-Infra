# Grab the SSH private key we uploaded manually
data "aws_secretsmanager_secret_version" "gitops_ssh_key" {
  secret_id = var.gitops_ssh_secret_arn  
}

# Create a kubernetes secret so our ArgoCD can grab it
resource "kubernetes_secret" "argocd_ssh_key" {
  metadata {
    name      = "argocd-ssh-key"
    namespace = "argocd"
    //argocd will not be able to access the secret without this label block
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  # Repo values
  data = {
    "sshPrivateKey" = data.aws_secretsmanager_secret_version.gitops_ssh_key.secret_string
    "type"          = "git"
    "url"           = "${var.gitops_repo_url}"
    "name"          = "github"
    "project"       = "*"
  }

  type = "Opaque"
}

