#type
#description
#default

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