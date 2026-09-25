data "azurerm_subnet" "subnets" {
  for_each = var.virtual_machine

  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}

data "azurerm_public_ip" "pips" {
  for_each = var.virtual_machine

  name                = each.value.public_ips_name
  resource_group_name = each.value.rg_name
}