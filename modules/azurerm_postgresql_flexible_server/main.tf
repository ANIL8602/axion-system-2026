resource "azurerm_postgresql_flexible_server" "postgresql_pgadmin" {
    for_each = var.postgresql_pgadmin

  name                   = each.value.postgresql_name
  resource_group_name    = each.value.rg_name
  location               = each.value.location
  version                = "16"
  public_network_access_enabled = "true"
  administrator_login    = each.value.admin_login
  administrator_password = each.value.admin_password
  storage_mb             = 32768
  zone = 1
  storage_tier = "P4"
  sku_name               = each.value.vm_size
}