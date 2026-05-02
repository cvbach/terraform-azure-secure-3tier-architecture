data "azurerm_resource_group" "cvbach" {
  name     = "cv.bach"
}

module "network" {
  source   = "./modules/network"
  resource_group_name  = data.azurerm_resource_group.cvbach.name
  location = var.location
}

module "compute" {
  source   = "./modules/compute"
  resource_group_name = data.azurerm_resource_group.cvbach.name
  location = var.location
  subnet_id = module.network.web_subnet_id
  vm_name = ["azr-webvm01", "azr-webvm02"]
}

module "loadbalancer" {
  source   = "./modules/loadbalancer"
  resource_group_name = data.azurerm_resource_group.cvbach.name
  location = var.location
  name     = "lb-azr"
  is_public = true
}
resource "azurerm_network_interface_backend_address_pool_association" "nic_lb" {
  count                   = length(module.compute.nic_ids)
  network_interface_id    = module.compute.nic_ids[count.index]
  ip_configuration_name   = "internal"
  backend_address_pool_id = module.loadbalancer.backend_pool_id
}

module "db" {
  source = "./modules/db"
  resource_group_name = data.azurerm_resource_group.cvbach.name
  location = var.location
  name_prefix = "azr-db01"

  admin_username = "azadmin"
  admin_password = "!imsi00000000"

  subnet_id = module.network.db_subnet_id
  vnet_id = module.network.vnet_id
}