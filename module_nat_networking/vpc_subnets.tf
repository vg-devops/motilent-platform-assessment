# Find existing VPC by CIDR block
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "cidr-block"
    values = [var.var_vpc_cidr]
  }
}

# Find existing public subnet
data "aws_subnet" "public" {
  vpc_id = data.aws_vpc.existing_vpc.id
  filter {
    name   = "cidr-block"
    values = [var.var_subnet_cidr_public]
  }
}

# Find existing private subnet
data "aws_subnet" "private" {
  vpc_id = data.aws_vpc.existing_vpc.id
  filter {
    name   = "cidr-block"
    values = [var.var_subnet_cidr_private]
  }
}

# Check if Inet gateway does exist
data "aws_internet_gateway" "does_exists" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
}

# Creat Inet GW if does not exist
resource "aws_internet_gateway" "new_igw" {
  count = try(data.aws_internet_gateway.does_exists.id, "") == "" ? 1 : 0
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name        = "igw-${var.var_environment}"
    Environment = var.var_environment
  }
}