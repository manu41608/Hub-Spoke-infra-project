resource "azurerm_public_ip" "appgw-publicip" {
  name                = "appgw-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

# since these variables are re-used - a locals block makes this more maintainable


resource "azurerm_application_gateway" "appgw" {
  name                = var.appgw-name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet
  }

  frontend_port {
    name = "frontend_port_name"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend_ip"
    public_ip_address_id = azurerm_public_ip.appgw-publicip.id
  }

 # Dynamic backend_address_pool
  dynamic "backend_address_pool" {
    for_each = local.appgw_config.backend_address_pools
    content {
      name = backend_address_pool.value.name
    }
  }

  # Dynamic backend_http_settings
  dynamic "backend_http_settings" {
    for_each = local.appgw_config.backend_http_settings
    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      path                  = backend_http_settings.value.path
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  # Dynamic http_listener
  dynamic "http_listener" {
    for_each = local.appgw_config.http_listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
    }
  }

  # Dynamic request_routing_rule
  dynamic "request_routing_rule" {
    for_each = local.appgw_config.request_routing_rules
    content {
      name                       = request_routing_rule.value.name
      priority                   = request_routing_rule.value.priority
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
    }
  }
}