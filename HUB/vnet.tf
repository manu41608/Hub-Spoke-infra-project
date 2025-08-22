module "rg" {
  source = "../modules/rg"
  rg-name = "hub-rg"
}
module "vnet" {
  source = "../modules/vnet"
  vnet-name = "hub-vnet"
  resource_group_name = module.rg.name
  location = module.rg.location
  
}
module "subnet" {
  source = "../modules/subnet"
  subnet = "hub-subnet"
  resource_group_name = module.rg.name
  vnet = module.vnet.name
}