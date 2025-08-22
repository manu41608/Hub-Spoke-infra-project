variable "rg-name" {
  type = string
  description = "resource group name"
  default = ""
}
variable "location" {
  type = string
  description = "location"
  default = "East US"
}


variable "tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Owner       = "Manu"
    Project     = "TerraformDemo"
  }
}
resource "azurerm_resource_group" "rg" {
  name     = var.rg-name
  location = var.location
  tags = var.tags

}

output "name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}