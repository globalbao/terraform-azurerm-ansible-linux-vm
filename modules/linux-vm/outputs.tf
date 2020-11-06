output "pip1" {
  value = azurerm_public_ip.pip1.fqdn
}

output "tls_private_key" {
  value = tls_private_key.vm1key.private_key_pem
}

output "azurerm_resource_group_name" {
  value = azurerm_resource_group.rg1.name
}

output "azurerm_virtual_network_name" {
  value = azurerm_virtual_network.vnet1.name
}