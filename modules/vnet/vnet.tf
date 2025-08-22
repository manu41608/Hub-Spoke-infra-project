
variable "vnet-name" {
  type = string
  description = "VNET"
  default = " "
}

variable "resource_group_name" {
  
}
variable "location" {
  
}
resource "azurerm_virtual_network" "vnet" {
  name               = var.vnet-name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}
output "name" {
  value = azurerm_virtual_network.vnet.name
}