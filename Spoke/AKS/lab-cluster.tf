module "rg" {
  source = "../../modules/rg"
  rg-name = "Spoke-rg"
}

module "vnet" {
  source = "../../modules/vnet"
  vnet-name = "spoke-vnet"
  resource_group_name = module.rg.name
  location = module.rg.location
}

module "subnet" {
  source = "../../modules/subnet"
  vnet = module.vnet.name
  resource_group_name = module.rg.name
}
module "aks" {
  source = "../../modules/aks"
  aks-name = "cluster1"
  aksdnsprefix = "cluster1devuk"
  rg = module.rg.name
  location = module.rg.location
  vnet = module.vnet.name
  subnet = module.subnet.subnet
}