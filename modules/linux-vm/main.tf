resource "azurerm_resource_group" "rg1" {
  name     = var.rgName
  location = var.rgLocation
}

resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnetName
  address_space       = var.vnetAddressSpace
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  subnet {
    name           = var.vnetSubnetName
    address_prefix = var.vnetSubnetAddress
    security_group = azurerm_network_security_group.subnet1nsg1.id
  }
}

resource "azurerm_network_security_group" "subnet1nsg1" {
  name                = var.nsgName
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_network_security_rule" "subnet1nsg1rule1" {
  name                        = var.nsgRule1["name"]
  description                 = var.nsgRule1["description"]
  priority                    = var.nsgRule1["priority"]
  direction                   = var.nsgRule1["direction"]
  access                      = var.nsgRule1["access"]
  protocol                    = var.nsgRule1["protocol"]
  source_port_range           = var.nsgRule1["source_port_range"]
  destination_port_range      = var.nsgRule1["destination_port_range"]
  source_address_prefix       = var.nsgRule1["source_address_prefix"]
  destination_address_prefix  = var.nsgRule1["destination_address_prefix"]
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.subnet1nsg1.name
}

resource "azurerm_public_ip" "pip1" {
  name                = var.vmName
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Dynamic"
  domain_name_label   = var.vmPublicIPDNS
}

resource "azurerm_network_interface" "nic1" {
  name                = var.vmName
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.default.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vmNICPrivateIP
    public_ip_address_id          = azurerm_public_ip.pip1.id
  }
}

resource "tls_private_key" "vm1key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = var.vmName
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = var.vmSize
  admin_username      = var.vmAdminName
  network_interface_ids = [
    azurerm_network_interface.nic1.id
  ]

  admin_ssh_key {
    username   = var.vmAdminName
    public_key = tls_private_key.vm1key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vmSrcImageReference["publisher"]
    offer     = var.vmSrcImageReference["offer"]
    sku       = var.vmSrcImageReference["sku"]
    version   = var.vmSrcImageReference["version"]
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm1" {
  virtual_machine_id = azurerm_linux_virtual_machine.vm1.id
  location           = azurerm_resource_group.rg1.location
  enabled            = true

  daily_recurrence_time = var.vmShutdownTime
  timezone              = var.vmShutdownTimeZone

  notification_settings {
    enabled = false
  }
}

resource "azurerm_virtual_machine_extension" "vm1extension" {
  name                 = var.vmName
  virtual_machine_id   = azurerm_linux_virtual_machine.vm1.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
        "fileUris":["https://raw.githubusercontent.com/globalbao/terraform-azurerm-ansible-linux-vm/master/scripts/ubuntu-setup-ansible.sh"]
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "commandToExecute": ". ./ubuntu-setup-ansible.sh"
    }
PROTECTED_SETTINGS
}