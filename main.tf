terraform {
  required_version = "~> 0.13.0"
  required_providers {
    azurerm = "~> 2.25.0"
  }
}

provider "azurerm" {
  features {
  }
}

module "linux_vm" {
  source = "./modules/linux-vm"

  rgName             = "ansible-devhost-${var.technician_initials}"
  rgLocation         = "australiaeast"
  vnetName           = "ansible-dev-vnet-${var.technician_initials}"
  vnetAddressSpace   = ["10.0.0.0/24"]
  vnetSubnetName     = "default"
  vnetSubnetAddress  = "10.0.0.0/24"
  nsgName            = "ansible-dev-subnet-nsg-${var.technician_initials}"
  vmNICPrivateIP     = "10.0.0.5"
  vmPublicIPDNS      = "ansibledevhost1-${var.technician_initials}"
  vmName             = "ansibledevhost1-${var.technician_initials}"
  vmSize             = "Standard_B2s"
  vmAdminName        = "ansibleadmin" #If this is changed ensure you update "./scripts/ubuntu-setup-ansible.sh" with the new username
  vmShutdownTime     = "1900"
  vmShutdownTimeZone = "AUS Eastern Standard Time"
  vmSrcImageReference = {
    "publisher" = "Canonical"
    "offer"     = "UbuntuServer"
    "sku"       = "18.04-LTS"
    "version"   = "latest"
  }
  nsgRule1 = {
    "name"                       = "SSH_allow"
    "description"                = "Allow inbound SSH from single Public IP to Ansible Host"
    "priority"                   = 100
    "direction"                  = "Inbound"
    "access"                     = "Allow"
    "protocol"                   = "Tcp"
    "source_port_range"          = "*"
    "destination_port_range"     = "22"
    "source_address_prefix"      = "0.0.0.0" #Update with your own public IP address https://www.whatismyip.com/
    "destination_address_prefix" = "10.0.0.5"
  }
}
