resource "azurerm_public_ip" "pips" {

    for_each = var.public_ips
    
  name                = each.value.public_ips_name
  resource_group_name = each.value.rg_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method

}