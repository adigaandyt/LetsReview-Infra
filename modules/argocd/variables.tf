#aws secretsmanager create-secret --name "argocd-ssh-key" --description "SSH Private Key for ArgoCD GitOps" --secret-string file:///home/andy/Develeap/freestyle/Task1_Argo/argo_key

variable argocd_values_filepath {
  type        = string
  description = "Path to ArgoCD values.yaml containing admin password and ingress config"
}


