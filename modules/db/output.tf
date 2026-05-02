output "sql_fqdn" {
  value = azurerm_mssql_server.sqlserver.fully_qualified_domain_name
}

output "sql_server_name" {
  value = azurerm_mssql_server.sqlserver.name
}