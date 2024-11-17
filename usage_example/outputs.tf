
output "nat_network_details" {
  value = {
    vpc_id              = module.nat_network.vpc_id
    nat_gateway_id      = module.nat_network.nat_gateway_id
    nat_public_ip       = module.nat_network.nat_gateway_public_ip
    public_route_table  = module.nat_network.public_route_table_id
    private_route_table = module.nat_network.private_route_table_id
  }
}