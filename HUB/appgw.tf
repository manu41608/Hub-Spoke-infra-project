module "appgw" {
  source = "../modules/appgw"
  appgw-name = "hub-appgw"
  appgw_config_file = var.appgw_config_file
  resource_group_name = module.rg.name
  location = module.rg.location
  subnet = module.subnet.subnet
 
}