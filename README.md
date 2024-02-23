# Infrastructure as Code for LetsReview
This repository contains Terraform configurations for provisioning and managing the cloud infrastructure (EKS) required by the [LetsReview](https://github.com/adigaandyt/LetsReview-App).
It defines the infrastructure in a declarative manner, ensuring consistency, reproducibility, and version control for all cloud resources.
Terraform Infrastructure as Code that deploys an EKS cluster and installs [ArgoCD](https://github.com/adigaandyt/LetsReview-GitOps) onto the cluster on deployment which is used for GitOps with an app of apps pattern.

## Prerequisites
Before you begin, you will need:

- Terraform installed
- AWS CLI With proper credentials
- An AWS account

## Repository Structure
-  `/argocd-files/argocd-values.yaml`: Holds values for ArgoCD that gets installed when the infrastructure gets built
-  `/argocd-files/bootstrap-app.yaml`: an application resource to point ArgoCD to the GitOps repo to bootstraps our application automatically, you can replace the repoURL with your own GitOps repo
- `/modules`: Reusable Terraform modules for various infrastructure components.
- `main.tf`: The main Terraform configuration file that ties everything together.
- `providers.tf`: Defines the required Terraform providers for AWS, Kubernetes, Helm, and Kubectl.
- `variables.tf`: Definition of variables used in the configurations.
- `outputs.tf`: Outputs after the Terraform apply.

## Repository Modules
- `/argocd/`: Installs ArgoCD onto the EKS Cluster when the infrastructure goes up, also creates 2 Kuberenets secrets<br>
> 1) `secret.tf` : fetches a secret from AWS Secret Manger which is the SSH key for the GitOps repo then creates a kubernetes secret with it <br>
> 2) `db-secret.tf` : fetches a secret from AWS Secret Manger and creates a kubernetes secret holding the login data for the database<br>

- `/eks/`: Deploys and EKS Cluster and an IAM role and policies attached <br>
- `/network/`: Deploys a VPC and public subnets based on the input value<br>
- `/nodes/`: Creates a node group of worker nodes and the necessary IAM roles and policies for them<br>

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

2) Provide your own .tfvars file
```
profile = "andyt-develeap"
default_tags = ["andyt","19","22-09-2024"]
name_prefix = "andy"
etc...
```
3) Deploy
```
terraform init 
terraform plan -var-file=<your .tfvars file>
terraform apply -var-file=<your .tfvars file>
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
