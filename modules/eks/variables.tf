#type
#description
#default
variable "name_prefix" {
  type        = string
  description = "A prefix for resources names to ensure uniqueness."
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to associate with the EKS cluster."
}