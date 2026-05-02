# Create public IP if is_public is true
resource "azurerm_public_ip" "lb_ip" {
  count               = var.is_public ? 1 : 0
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}
# Load Balancer
resource "azurerm_lb" "lb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name = "frontend"

    public_ip_address_id = var.is_public ? azurerm_public_ip.lb_ip[0].id : null
    subnet_id            = var.is_public ? null : var.subnet_id
    private_ip_address   = var.is_public ? null : var.frontend_private_ip
  }
}

# Backend pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name                = "${var.name}-backendpool"
  loadbalancer_id     = azurerm_lb.lb.id
}

# Health probe
resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "${var.name}-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}
# Rule
resource "azurerm_lb_rule" "rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "${var.name}-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend"
  probe_id                       = azurerm_lb_probe.probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
}