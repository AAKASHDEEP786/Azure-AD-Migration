# -------------------------------
# Target Public IP
# -------------------------------
resource "azurerm_public_ip" "target_pip" {
  name                = "target-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# -------------------------------
# Target NIC
# -------------------------------
resource "azurerm_network_interface" "target_nic" {
  name                = "target-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # DNS → source DC
  dns_servers = ["10.0.1.4"]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.5"
    public_ip_address_id          = azurerm_public_ip.target_pip.id
  }
}

# -------------------------------
# NSG Association (RDP enable)
# -------------------------------
resource "azurerm_network_interface_security_group_association" "target_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.target_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# -------------------------------
# Target VM
# -------------------------------
resource "azurerm_windows_virtual_machine" "target_vm" {
  name                = "target-ad-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.target_nic.id,
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

# -------------------------------
# Target Data Disk
# -------------------------------
resource "azurerm_managed_disk" "target_data_disk" {
  name                 = "target-ad-vm-datadisk"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}

resource "azurerm_virtual_machine_data_disk_attachment" "target_disk_attach" {
  managed_disk_id    = azurerm_managed_disk.target_data_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.target_vm.id
  lun                = 0
  caching            = "ReadWrite"
}

# -------------------------------
# AD Installation (target.local)
# -------------------------------
resource "azurerm_virtual_machine_extension" "target_ad_install" {
  name                 = "target-ad-install"
  virtual_machine_id   = azurerm_windows_virtual_machine.target_vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
  {
    "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \"$script=[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${filebase64("scripts/install-ad-target.ps1")}')); Set-Content -Path C:\\\\install-ad-target.ps1 -Value $script; powershell -ExecutionPolicy Unrestricted -File C:\\\\install-ad-target.ps1\""
  }
  SETTINGS
}