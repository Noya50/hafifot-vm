output "name" {
  value       = azurerm_linux_virtual_machine.this[0].name
  description = "The name of the vm."
}

output "id" {
  value       = azurerm_linux_virtual_machine.this[0].id
  description = "The id of the vm."
}

output "location" {
  value       = azurerm_linux_virtual_machine.this[0].location
  description = "The location of the vm."
}

output "resource_group_name" {
  value       = azurerm_linux_virtual_machine.this[0].resource_group_name
  description = "The name of the resource group of the vm."
}

output "vm_private_ip" {
  value       = azurerm_network_interface.this.private_ip_address
  description = "The private ip of the vm."
}
