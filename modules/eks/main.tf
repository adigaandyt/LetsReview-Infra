#Create an IAM Role
#Allow EKS to assume this role
resource "aws_iam_role" "eksrole" {
  name = "${var.name_prefix}-cluster-policy"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# EKS Cluster Policy required for each cluster to manage nodes and loadbalancers
resource "aws_iam_role_policy_attachment" "myAmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eksrole.name
}

# Create an EKS Cluster
resource "aws_eks_cluster" "mycluster" {
  name     = "${var.name_prefix}-cluster"
  role_arn = aws_iam_role.eksrole.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Cluster wont be created until the proper iam role is ready
  depends_on = [aws_iam_role_policy_attachment.myAmazonEKSClusterPolicy]
}