
# ✅ Data source for existing Resource Group (Spoke)
data "azurerm_resource_group" "spoke_rg" {
  name = "spoke-rg"
}


# ✅ Data source for existing Spoke VNet
data "azurerm_virtual_network" "spoke_vnet" {
  name                = "spoke-vnet"
  resource_group_name = data.azurerm_resource_group.spoke_rg.name
}

# ✅ Data source for Subnet
data "azurerm_subnet" "subnet" {
  name                 = "aks-subnet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# Data source for existing Firewall
data "azurerm_firewall" "fw" {
  name                = "hub-firewall"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Data source for Public IP attached to Firewall
data "azurerm_public_ip" "fw_pip" {
  name                = data.azurerm_firewall.fw.ip_configuration[0].public_ip_address_id
  resource_group_name = data.azurerm_resource_group.rg.name
}
resource "azurerm_route_table" "example" {
  name                = "spoke-routetable"
  location            = data.azurerm_resource_group.spoke_rg.location
  resource_group_name = data.azurerm_resource_group.spoke_rg.name

  route {
    name                   = "outgoing"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = data.azurerm_public_ip.fw_pip.ip_address
  }
}

resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = data.azurerm_subnet.subnet.id
  route_table_id = azurerm_route_table.example.id
}