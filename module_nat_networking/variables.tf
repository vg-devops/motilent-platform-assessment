variable "var_vpc_cidr" {
  type        = string
  description = "CIDR block to filter out the existing VPC"
}

variable "var_subnet_cidr_public" {
  type        = string
  description = "CIDR block to filter out the existing public subnet"
}

variable "var_subnet_cidr_private" {
  type        = string
  description = "CIDR block to filter out the existing private subnet"
}

variable "var_environment" {
  type        = string
  description = "Environment to be used for resource tagging"
}