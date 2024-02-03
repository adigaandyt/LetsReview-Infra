# output "argocd_server_url" {
#   value = try("https://${helm_release.argocd.status[0].load_balancer.ingress[0].hostname}", "URL not available")
# }
