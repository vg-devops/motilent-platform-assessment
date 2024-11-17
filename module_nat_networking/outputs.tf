output "vpc_id" {
  value = data.aws_vpc.existing_vpc.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "nat_gateway_public_ip" {
  value = aws_eip.nat_ip.public_ip
}