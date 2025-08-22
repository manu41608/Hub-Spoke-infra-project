
variable "aksdnsprefix" {
  default = "aksproduk"
}
variable "aks-name" {
  type = string
  default = "mycluster"
}
variable "rg" {  

}
variable "location" {  
}
variable "vnet" {
}
variable "subnet" { 
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks-name
  location            = var.location
  resource_group_name = var.rg
  dns_prefix          = var.aksdnsprefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = var.subnet
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw

  sensitive = true
}