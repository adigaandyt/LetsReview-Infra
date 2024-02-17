#>Providers
variable "profile" {
  type        = string
  description = "AWS config profile"
  default = "andyt-develeap"
}

variable "default_tags" {
  type        = list(string)
  description = "Default tags for all resources. Format: [owner, bootcamp, expiration_date]"
  default = ["andyt","19","22-09-2024"]
}

#>Network
variable "vpc_cidr_block" {
  type        = string
  description = "Specifies the VPC CIDR block."
  default = "10.0.0.0/16"
}

variable "subnet_cidr_offset" {
  type        = number
  description = "The prefix length offset used to calculate the CIDR blocks for subnets. This value determines the number of bits reserved for the subnet prefix within the VPC CIDR block. For example, a subnet offset of 8 from /16 would result in subnets with a /24 prefix length."
  default     = 8
}

variable "name_prefix" {
  type        = string
  description = "String to be added to the beginning of every resource's Name tag (example: [name_prefix]-vpc)"
  default     = "My"
}

variable "subnet_count" {
  type        = number
  description = "Number of subnets to create"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

#>ArgoCD
variable "argocd_values_filepath" {
  type        = string
  description = "Path to ArgoCD's values.yaml"
  default = "./argocd-files/argocd-values.yaml"
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
variable gitops_repo_url {
  type        = string
  description = "The SSH URL of your GitOps repo"
}

#>Nodes

#Maybe make this into an array like the tags
variable "ng_max_size" {
  type        = number
  description = "Maximum number of EC2 instances the node group can scale out to."
  default     = 3
}
variable "ng_min_size" {
  type        = number
  description = "Minimum number of EC2 instances maintained in the node group."
  default = 1
}
variable "ng_desired_size" {
  type        = number
  description = "Desired number of EC2 instances in the node group."
  default     = 2
}
variable "ng_max_unavailable" {
  type        = number
  description = "Maximum number of instances that can be unavailable during updates."
  default     = 1
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance types for the EKS node group."
  default     = ["t3a.medium"] 
}


