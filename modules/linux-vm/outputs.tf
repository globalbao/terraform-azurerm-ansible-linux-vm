output "pip1" {
  value = "${azurerm_public_ip.pip1.fqdn}"
}

output "tls_private_key" {
  value = "${tls_private_key.vm1key.private_key_pem}"
}
