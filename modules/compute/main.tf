resource "azurerm_network_interface" "nic" {
  count = length(var.vm_name)
  name                = "nic-${var.vm_name[count.index]}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count = length(var.vm_name)
  name                = var.vm_name[count.index]
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = "azadmin"
  admin_password      = "!imsi00000000"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    name                 = "osdisk-${var.vm_name[count.index]}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  secure_boot_enabled = false
  vtpm_enabled        = true

}
resource "azurerm_virtual_machine_extension" "web_setup" {
  count                = length(var.vm_name)
  name                 = "web-setup-${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -Command \"Invoke-WebRequest https://raw.githubusercontent.com/cvbach/terraform-azure-secure-3tier-architecture/refs/heads/main/setup-web.ps1 -OutFile C:\\temp\\setup.ps1; powershell -ExecutionPolicy Unrestricted -File C:\\temp\\setup.ps1\""
  })
}