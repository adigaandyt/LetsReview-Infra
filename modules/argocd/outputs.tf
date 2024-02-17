# output "argocd_server_url" {
#   value = try("https://${helm_release.argocd.status[0].load_balancer.ingress[0].hostname}", "URL not available")
# }
# output "gitops_ssh_secret_string" {
#   value     = data.aws_secretsmanager_secret_version.gitops-ssh-key.secret_string
#   sensitive = true
# }
