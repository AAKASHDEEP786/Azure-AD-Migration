resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  provision_vm_agent = true
}

# Data Disk
resource "azurerm_managed_disk" "data_disk" {
  name                 = "${var.vm_name}-datadisk"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  managed_disk_id    = azurerm_managed_disk.data_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = 0
  caching            = "ReadWrite"
}

# AD Installation using Custom Script Extension (FINAL)
resource "azurerm_virtual_machine_extension" "ad_install" {
  name                 = "${var.vm_name}-ad-install"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
  {
    "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \"$script=[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${filebase64("scripts/install-ad.ps1")}')); Set-Content -Path C:\\\\install-ad.ps1 -Value $script; powershell -ExecutionPolicy Unrestricted -File C:\\\\install-ad.ps1\""
  }
  SETTINGS
}