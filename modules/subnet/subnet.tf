
variable "subnet" {
  default = ""
}
variable "address_prefixes" {
  default = ["10.0.1.0/24"]
}
variable "resource_group_name" {
  
}
variable "vnet" {
  
}
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet
  address_prefixes     = var.address_prefixes
}

output "subnet" {
  value = azurerm_subnet.subnet.id
}