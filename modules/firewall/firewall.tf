
resource "azurerm_public_ip" "publicip" {
  name                = "fireallip"
  location            = var.location
  resource_group_name = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {
  name                = var.firewall
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}
//DNAT rule
resource "azurerm_firewall_nat_rule_collection" "DNAT" {
  name                = "DNAT-RULE"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Dnat"
  dynamic rule {
    for_each = local.DNAT_rules
    content {
      name = rule.value.name

      source_addresses = rule.value.source_addresses

      destination_ports = rule.value.destination_ports
  
      destination_addresses = [
        azurerm_public_ip.publicip.ip_address
      ]
  
      translated_port = rule.value.translated_port
  
      translated_address = rule.value.translated_address
  
      protocols = rule.value.protocols
    }
  }
}
//application-rule

resource "azurerm_firewall_application_rule_collection" "application-rule" {
  name                = "application-rule"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

 dynamic rule {
   for_each = local.application_rules
   content {
     name = rule.value.name

    source_addresses = rule.value.source_addresses

    target_fqdns = rule.value.target_fqdns

    dynamic "protocol" {
        for_each = rule.value.protocol
        content {
          type = protocol.value.type
          port = protocol.value.port
        }
      }
   }
  }
}