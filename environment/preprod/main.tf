module "rg" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs
}


module "vnet" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_virtual_network"
  vnets      = var.vnets
}

module "subnet" {
  depends_on = [module.vnet]
  source     = "../../modules/azurerm_subnet"
  subnets    = var.subnets
}

module "public_ips" {
   depends_on = [ module.rg ]
  source  = "../../modules/azurerm_public-ip"
  public_ips = var.public_ips
}

module "virtual_machine" {
  depends_on = [ module.public_ips,module.subnet ]
  source = "../../modules/azurerm_virtual_machine"
  virtual_machine = var.virtual_machine
  
}