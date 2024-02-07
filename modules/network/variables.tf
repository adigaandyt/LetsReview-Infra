#type
#description
#default


variable vpc_cidr_block {
  type        = string
  description = "Specifies the VPC CIDR block."
  default = "10.0.0.0/16"
}

variable subnet_cidr_offset {
  type        = number
  description = "The prefix length offset used to calculate the CIDR blocks for subnets. This value determines the number of bits reserved for the subnet prefix within the VPC CIDR block. For example, a subnet offset of 8 would result in subnets with a /24 prefix length."
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

# Doing this instead of number of zones just incase
# we want to skip a zone (so it's not just a b c d)
variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}




# Turn AZ's to count using data from root if u have time
# variable "aws_region" {
#   description = "The AWS region where resources will be created"
#   type        = string
# }

# data "aws_availability_zones" "available" {
#   state = "available"
#   # Optionally filter by region if needed. Generally, the provider's region is automatically used.
# }


# Could also add a boolean for private vpc