locals {
  igw_id = try(data.aws_internet_gateway.does_exists.id, aws_internet_gateway.new_igw[0].id)
   
  public_subnet_az  = data.aws_subnet.public.availability_zone
  private_subnet_az = data.aws_subnet.private.availability_zone
  # Check if both subnets share the same AZ
  subnets_are_in_same_az = local.public_subnet_az == local.private_subnet_az

  # nessage if validation failed
  error_in_validation_message = "Public subnet AZ (${local.public_subnet_az}) and Private subnet AZ (${local.private_subnet_az}) shall be in the same availability zone as per user req't"
}