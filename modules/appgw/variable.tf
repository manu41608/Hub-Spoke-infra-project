variable "appgw-name" {
  default = ""
}

variable "appgw_config_file" {
  default = "appgw.json"
}

locals {
  appgw_config = jsondecode(file(var.appgw_config_file))
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}
variable "location" {
  
}
variable "subnet" {
  
}