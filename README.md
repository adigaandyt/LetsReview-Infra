# Infrastructure as Code for Our_Library
This repository contains Terraform configurations for provisioning and managing the cloud infrastructure (EKS) required by the [Our_Library](https://github.com/adigaandyt/Our_Library).
It defines the infrastructure in a declarative manner, ensuring consistency, reproducibility, and version control for all cloud resources.
Terraform Infrastructure as Code that deploys an EKS cluster and installs ArgoCD onto the cluster on deployment.
It's a part of a CI/CD project for [Our_Library](https://github.com/adigaandyt/Our_Library), an app that gets deployed onto the EKS Cluster

## Prerequisites
Before you begin, you will need:

- Terraform installed
- AWS CLI With proper credentials
- An AWS account

## Repository Structure
- `/modules`: Reusable Terraform modules for various infrastructure components.
- `/argocd-files`: Holds values for ArgoCD that gets installed when the infrastructure gets built 
- `main.tf`: The main Terraform configuration file that ties everything together.
- `providers.tf`: Defines the required Terraform providers for AWS, Kubernetes, Helm, and Kubectl.
- `variables.tf`: Definition of variables used in the configurations.
- `outputs.tf`: Outputs after the Terraform apply.

## Repository Modules
-`/argocd/`: Installs ArgoCD onto the EKS Cluster when the infrastructure goes up
-`/eks/`: Deploys and EKS Cluster and an IAM role and policies attached 
-`/network/`: Deploys a VPC and public subnets based on the input value
-`/nodes/`: Creates a node group of worker nodes and the necessary IAM roles and policies for them

## Getting Started
in `providers.tf` "
1) Set your own S3 Bucket
```  
backend "s3" {
    bucket  = "andyt-s3-bucket"
    key     = "terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
```
2) Set region, credentials and tags
```
provider "aws" {
  region                   = "eu-west-1" # Directly specify the region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "andyt-develeap"
  default_tags {
    tags = {
      owner           = "andyt"
      bootcamp        = "19"
      expiration_date = "22-09-2024"
    }
  }
}
```
3) Update `main.tf` with your own values (will have a proper .tfvars files later on)
4) Deploy
```
terraform init
terraform plan
terraform apply
```

## Architecture
Here is a very basic diagram of the architecture
![AWS Infrastructure](./diagrams/AWS%20Infra.png)

### Network
- **VPC** : A virtual private cloud to host the EKS
- **2 Public subnets** : Two public subnets in two AZs for high availability 
- **Internet Gateway** : To give access to the VPC from the internet 
- **Route Table** : to direct outbound traffic to the Internet Gateway

### EKS
- **Cluster** : A Kubernetes cluster managed by AWS
- **Node Group** : A node group with two EC2 nodes
- **Load Balancer** : Automatically created by EKS
- **EBS** : Elastic Block Store volumes automatically created by EKS and attached to EC2 nodes

### IAM Roles
IAM Roles get created in the code and resources assume them
- **EKS Cluster Role** : `eks/main.tf -> eksrole` Enables AWS EKS to manage the cluster and its resources.<br>
  *Policy Attached*:<br>`AmazonEKSClusterPolicy` permissions for EKS to create and manage the cluster's resources.
  
- **Worker Node Role** : `nodes/main.tf -> nodes` IAM role for EC2 worker nodes to interact with AWS services<br>
  *Policies Attached*:<br>
                    `AmazonEKSWorkerNodePolicy` : Provides permissions for EKS worker nodes to make calls to AWS APIs.<br>
                    `AmazonEKS_CNI_Policy` : Allows the worker nodes to manage networking resources for pods using the Amazon VPC CNI plugin.<br>
                    `AmazonEC2ContainerRegistryReadOnly` : Grants read-only access to Amazon ECR for downloading and running docker images.<br>
                    `AmazonEBSCSIDriverPolicy` : Enables the EKS worker nodes to use the EBS CSI driver for managing persistent volumes using EBS.<br>

### ECR
- **Amazon Elastic Container Registry** : A private repository created manually to host Our_Library images
