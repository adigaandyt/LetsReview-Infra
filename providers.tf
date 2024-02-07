


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.11.3"
    }
  }

  backend "s3" {
    bucket  = "andyt-s3-bucket"
    key     = "terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = "eu-west-1" # Directly specify the region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = var.profile
  default_tags {
    tags = {
      owner           = var.default_tags[0]
      bootcamp        = var.default_tags[1]
      expiration_date = var.default_tags[2]
    }
  }
}

resource "null_resource" "wait_for_eks" {
  depends_on = [module.eks]  # Ensure that the null_resource waits for the eks module to complete
}
# Fetch EKS cluster details
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [null_resource.wait_for_eks] 
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
  depends_on = [null_resource.wait_for_eks] 
}

# Assuming module.eks exposes cluster details like endpoint and CA certificate
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubectl" {
  # Dynamically configure the kubectl provider based on EKS cluster details
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

