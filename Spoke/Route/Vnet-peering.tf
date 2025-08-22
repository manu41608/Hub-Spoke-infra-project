

# ✅ Data source for existing Resource Group (Hub)
data "azurerm_resource_group" "hub_rg" {
  name = "hub-rg"
}

# ✅ Data source for existing Resource Group (Spoke)
data "azurerm_resource_group" "spoke_rg" {
  name = "spoke-rg"
}

# ✅ Data source for existing Hub VNet
data "azurerm_virtual_network" "hub_vnet" {
  name                = "hub-vnet"
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

# ✅ Data source for existing Spoke VNet
data "azurerm_virtual_network" "spoke_vnet" {
  name                = "spoke-vnet"
  resource_group_name = data.azurerm_resource_group.spoke_rg.name
}

# ✅ Create VNet Peering from Hub to Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = data.azurerm_resource_group.hub_rg.name
  virtual_network_name      = data.azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.spoke_vnet.id

  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

# ✅ Create VNet Peering from Spoke to Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-to-hub"
  resource_group_name       = data.azurerm_resource_group.spoke_rg.name
  virtual_network_name      = data.azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.hub_vnet.id

  allow_forwarded_traffic   = true
  use_remote_gateways       = true
}

