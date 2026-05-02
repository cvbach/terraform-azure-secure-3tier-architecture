resource "azurerm_mssql_server" "sqlserver" {
  name                         = "${var.name_prefix}-sql"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"

  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "appdb" {
  name      = "${var.name_prefix}-db"
  server_id = azurerm_mssql_server.sqlserver.id

  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "Basic"
}

resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "${var.name_prefix}-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "pe" {
  name                = "${var.name_prefix}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "sql-connection"
    private_connection_resource_id = azurerm_mssql_server.sqlserver.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}
