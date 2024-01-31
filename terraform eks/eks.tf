#IAM role with the EKS cluster policy
resource "aws_iam_role" "eksrole" {
  name = "andy-eks-cluster-policy"

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

resource "aws_iam_role_policy_attachment" "myAmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eksrole.name
}

resource "aws_eks_cluster" "mycluster" {
  name     = "andy-cluster"
  role_arn = aws_iam_role.eksrole.arn

  vpc_config {
    subnet_ids = [
      # aws_subnet.mysubnet1.id,
      # aws_subnet.mysubnet2.id,
      aws_subnet.mysubnet3.id,
      aws_subnet.mysubnet4.id
    ]
  }

  # Cluster wont be created until the proper iam role is ready
  depends_on = [aws_iam_role_policy_attachment.myAmazonEKSClusterPolicy]
}
