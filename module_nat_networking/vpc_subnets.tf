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


# Creates Elastic IP for NAT GW
resource "aws_eip" "nat_ip" {
  domain = "vpc"

  tags = {
    Name        = "nat-eip-${var.var_environment}"
    Environment = var.var_environment
  }
}

# Creates NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = data.aws_subnet.public.id

  tags = {
    Name        = "nat-gateway-${var.var_environment}"
    Environment = var.var_environment
  }

  depends_on = [
        local.igw_id,
        terraform_data.availability_zones_validator
    ]
}

# Adds public route table - there is little caveat that default route table my already include it, but not a show stopper
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.existing_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.igw_id
  }

  tags = {
    Name        = "rt-public-${var.var_environment}"
    Environment = var.var_environment
  }
}

# Adds private route table
resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.existing_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "rt-private-${var.var_environment}"
    Environment = var.var_environment
  }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = data.aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = data.aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "terraform_data" "availability_zones_validator" {
    lifecycle {
        precondition {
            condition     = local.subnets_are_in_same_az
            error_message = local.error_in_validation_message
        }
  }
}