variable "name_prefix" {
  type        = string
  description = "String to be added to the beginning of every resource's Name tag (example: [name_prefix]-vpc)"
  default     = "My"
}

variable "eks_name" {
  type        = string
  description = "Cluster name for node group"
}

variable "ng_max_size" {
  type        = number
  default     = 3
  description = "Maximum number of EC2 instances the node group can scale out to."
}
variable "ng_min_size" {
  type        = number
  default = 1
  description = "Minimum number of EC2 instances maintained in the node group."
}
variable "ng_desired_size" {
  type        = number
  default     = 2
  description = "Desired number of EC2 instances in the node group."
}
variable "ng_max_unavailable" {
  type        = number
  default     = 1
  description = "Maximum number of instances that can be unavailable during updates."
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to associate with the node group."
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance types for the EKS node group."
  default     = ["t3a.medium"] 
}
