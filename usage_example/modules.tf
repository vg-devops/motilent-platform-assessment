module "nat_network" {
  source = "../module_nat_networking"

  var_vpc_cidr            = "172.31.0.0/16"
  var_subnet_cidr_public  = "172.31.0.0/20"
  var_subnet_cidr_private = "172.31.48.0/20"
  var_environment         = "development"
}