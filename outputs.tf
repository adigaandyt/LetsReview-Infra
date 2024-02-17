# output "argocd_server_url" {
#   value = module.argocd.argocd_server_url
# }

# output "argocd_ingress_hostname" {
#   value = data.kubectl_path_documents.argocd_ingress.result
# }

# output "gitops_ssh_secret_string" {
#   value     = module.argocd.gitops_ssh_secret_string
#   sensitive = true
# }