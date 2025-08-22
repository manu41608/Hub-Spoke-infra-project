variable "firewall" {
  default = ""
}
variable "DNAT-rules" {
  default = ""
}
variable "application_rules" {
  default = ""
}
variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}
variable "location" {
  type     = string
}
variable "subnet" {
  type = string
}
