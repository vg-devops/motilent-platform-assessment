locals {
  igw_id = try(data.aws_internet_gateway.does_exists.id, aws_internet_gateway.new_igw[0].id)
   
  public_subnet_az  = data.aws_subnet.public.availability_zone
  private_subnet_az = data.aws_subnet.private.availability_zone
  # Check if both subnets share the same AZ
  subnets_are_in_same_az = local.public_subnet_az == local.private_subnet_az
}