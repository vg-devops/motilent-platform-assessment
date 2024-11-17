locals {
  igw_id = try(data.aws_internet_gateway.does_exists.id, aws_internet_gateway.new[0].id)
}