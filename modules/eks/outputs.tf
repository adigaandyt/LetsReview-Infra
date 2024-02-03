# Inside your EKS module

output "cluster_name" {
  value = aws_eks_cluster.mycluster.name
  description = "The name of the created EKS cluster."
}

#Useful for configuring Kubernetes clients (like kubectl or other CI/CD tools) to communicate with your cluster.
output "cluster_endpoint" {
  value = aws_eks_cluster.mycluster.endpoint
  description = "The endpoint for the EKS cluster API."
}

#Necessary for clients to securely communicate with the cluster's API server.
#Maybe needed when I add TLS
output "cluster_ca_certificate" {
  value = aws_eks_cluster.mycluster.certificate_authority[0].data
  description = "The base64 encoded certificate data required to communicate with the cluster."
}

#Useful if any external AWS service or resource needs to interact with your cluster and requires the cluster's IAM role for permissions.
output "cluster_iam_role_arn" {
  value = aws_iam_role.eksrole.arn
  description = "The ARN of the IAM role associated with the EKS cluster."
}
