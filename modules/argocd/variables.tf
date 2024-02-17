#aws secretsmanager create-secret --name "argocd-ssh-key" --description "SSH Private Key for ArgoCD GitOps" --secret-string file:///home/andy/Develeap/freestyle/Task1_Argo/argo_key

variable argocd_values_filepath {
  type        = string
  description = "Path to ArgoCD values.yaml containing admin password and ingress config"
}


variable "gitops_ssh_secret_arn" {
  type        = string
  description = "ARN of the AWS Secrets Manager secret containing the SSH private key for the GitOps repo"
}

variable "gitops_ssh_key_name" {
  description = "The name of the SSH private key in the AWS Secrets Manager Secret (the key from the Key/Value pair)"
  type        = string
}


variable bootstrap_application_path {
  type        = string
  description = "Path to bootsrap application resource manifest"
}

//git@github.com:adigaandyt/ourlibrary_gitops.git

variable gitops_repo_url {
  type        = string
  description = "The SSH URL of your GitOps repo"
}