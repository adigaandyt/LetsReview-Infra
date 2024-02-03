
resource "kubernetes_secret" "argocd_ssh_key" {
  metadata {
    name      = "argocd-ssh-key"
    namespace = "argocd"
  }

  data = {
    "sshPrivateKey" = data.aws_secretsmanager_secret_version.ssh_key_version.secret_string
  }

  type = "Opaque"
}
