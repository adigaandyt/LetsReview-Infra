#VPC ID for EKS Cluster.
output "vpc_id" {
  value       = aws_vpc.myvpc.id
}
#Subnet IDs for EKS worker nodes and networking.
output "subnet_ids" {
  value = aws_subnet.subnet[*].id
}
