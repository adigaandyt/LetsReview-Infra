# Output the ARN of the node group
output "node_group_arn" {
  value       = aws_eks_node_group.public-nodes.arn
  description = "The ARN of the EKS node group."
}

# Output the name of the node group
output "node_group_name" {
  value       = aws_eks_node_group.public-nodes.node_group_name
  description = "The name of the EKS node group."
}

# Output the IAM role ARN used by the nodes
output "node_role_arn" {
  value       = aws_iam_role.nodes.arn
  description = "The ARN of the IAM role used by the EKS nodes."
}


#Node Group ARN and Name: Outputting the Amazon Resource Name (ARN) and name of the node group can be useful for referencing the node group in IAM policies, monitoring, or when using AWS CLI or SDKs to query details about the node group.

#Node Role ARN: Since you're creating an IAM role for the nodes, outputting this role's ARN can be helpful if other resources or services need to reference or attach policies to this role outside of this module.

