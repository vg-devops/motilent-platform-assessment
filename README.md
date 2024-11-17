# AWS VPC NAT Networking Module

This Terraform module configures networking components in the existing VPC, including Internet Gateway, NAT Gateway, and route tables for one public and one private subnet.

## Features

- Uses existing VPC and subnets
- Creates Internet Gateway if not present
- Creates NAT Gateway in public subnet
- Configures routing tables for existing public and private subnets
- Validates that public and private subnets share the same Availability Zone
- Applies consistent resource tagging using "environment" variable

## Prerequisites

- Existing VPC with known CIDR block
- Existing public and private subnets with known CIDR blocks
- Subnets must be in the same Availability Zone
- AWS Provider configured

## Usage

```hcl
module "nat_network" {
  source = "./path/to/this_module"
  var_vpc_cidr            = "10.0.0.0/16"    # Your existing VPC CIDR
  var_subnet_cidr_public  = "10.0.1.0/24"    # Your existing public subnet CIDR
  var_subnet_cidr_private = "10.0.2.0/24"    # Your existing private subnet CIDR
  var_environment         = "development"    # Environment tag value
}

