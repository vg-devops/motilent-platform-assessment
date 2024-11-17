# Find existing VPC by CIDR block
data "aws_vpc" "existing" {
  filter {
    name   = "cidr-block"
    values = [var.var_vpc_cidr]
  }
}

# Find existing public subnet
data "aws_subnet" "public" {
  vpc_id = data.aws_vpc.existing.id
  filter {
    name   = "cidr-block"
    values = [var.var_subnet_cidr_public]
  }
}

# Find existing private subnet
data "aws_subnet" "private" {
  vpc_id = data.aws_vpc.existing.id
  filter {
    name   = "cidr-block"
    values = [var.var_subnet_cidr_private]
  }
}
