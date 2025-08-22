module "myfirewall" {
  source = "../modules/firewall"
  firewall = "hub-firewall"
  DNAT-rules = var.DNAT-rules
  application_rules = var.application-rules
  resource_group_name = module.rg.name
  subnet = module.subnet.subnet
  location = module.rg.location
}