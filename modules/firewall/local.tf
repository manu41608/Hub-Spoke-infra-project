locals {
  DNAT_rules = jsondecode(file(var.DNAT-rules))
}
locals {
  application_rules = jsondecode(file(var.application_rules))
}