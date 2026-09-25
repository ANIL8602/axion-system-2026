resource "azurerm_network_security_group" "nsg" {
  for_each = var.virtual_machine
  name                = each.value.nsg_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  security_rule {
    name                       = "test0123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nics" {
  for_each = var.virtual_machine
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnets[each.key].id
    public_ip_address_id          = data.azurerm_public_ip.pips[each.key].id  
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg-nic-association" {
  for_each =  var.virtual_machine

  network_interface_id      = azurerm_network_interface.nics[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
} 

resource "azurerm_linux_virtual_machine" "vms" {
  for_each = var.virtual_machine
  name                = each.value.name
  resource_group_name = each.value.rg_name
  location            = each.value.location
  size                = each.value.vm_size
  admin_username      = each.value.admin_username
  network_interface_ids = [
    azurerm_network_interface.nics[each.key].id,
  ]
 
  disable_password_authentication = false
  admin_password                  = each.value.admin_password
              
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}