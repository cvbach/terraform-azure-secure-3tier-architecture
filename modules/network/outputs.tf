output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "web_subnet_id" {
  value = azurerm_subnet.web.id
}
output "db_subnet_id" {
  value = azurerm_subnet.db.id
}
output "nsg_id" {
  value = azurerm_network_security_group.nsg_web.id
}