resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.53.13" # Specify the version you want to use

  values = [
    "${file(var.values_filepath)}"
  ]

  depends_on = [
    kubernetes_namespace.argocd,
    kubernetes_secret.argocd_ssh_key # argo could be up before the secret and so it wouldn't be able to set the password
  ]
}

# manually uploaded private ssh key to AWS secret manager
data "aws_secretsmanager_secret" "ssh_key" {
  name = "argocd-ssh-key"
}

data "aws_secretsmanager_secret_version" "ssh_key_version" {
  secret_id = data.aws_secretsmanager_secret.ssh_key.id
}

