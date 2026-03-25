output "vm_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "vm_private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}

output "target_vm_public_ip" {
  value = azurerm_public_ip.target_pip.ip_address
}

output "target_vm_private_ip" {
  value = azurerm_network_interface.target_nic.private_ip_address
}