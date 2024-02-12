resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name = var.eks_name
  addon_name   = "aws-ebs-csi-driver"

  depends_on = [aws_eks_node_group.public-nodes]
}
resource "aws_eks_addon" "kube-proxy" {
  cluster_name = var.eks_name
  addon_name   = "kube-proxy"

  depends_on = [aws_eks_node_group.public-nodes]
}
resource "aws_eks_addon" "coredns" {
  cluster_name = var.eks_name
  addon_name   = "coredns"

  depends_on = [aws_eks_node_group.public-nodes]
}
resource "aws_eks_addon" "vpc-cni" {
  cluster_name = var.eks_name
  addon_name   = "vpc-cni"

  depends_on = [aws_eks_node_group.public-nodes]
}