data "azurerm_client_config" "current" {}

data "azurerm_subnet" "default" {
  name                 = var.vnetSubnetName
  virtual_network_name = var.vnetName
  resource_group_name  = var.rgName
  depends_on = [
    azurerm_virtual_network.vnet1
  ]
}

variable "rgName" {
  type        = string
  description = "resource group name"
  default     = "ansible-devhost-rg"
}

variable "rgLocation" {
  type        = string
  description = "resource group location"
  default     = "australiaeast"
}

variable "vnetName" {
  type        = string
  description = "virtual network name"
  default     = "ansible-dev-vnet"
}

variable "vnetAddressSpace" {
  type        = list
  description = "virtual network address space"
  default     = ["10.0.0.0/24"]
}

variable "vnetSubnetName" {
  type        = string
  description = "virtual network default subnet name"
  default     = "default"
}

variable "vnetSubnetAddress" {
  type        = string
  description = "virtual network default subnet"
  default     = "10.0.0.0/24"
}

variable "nsgName" {
  type        = string
  description = "network security group name"
  default     = "default-subnet-nsg"
}

variable "nsgRule1" {
  type        = map
  description = "network security group rule 1"
  default = {
    "name"                       = "SSH_allow"
    "description"                = "Allow inbound SSH from single Public IP to Ansible Host"
    "priority"                   = 100
    "direction"                  = "Inbound"
    "access"                     = "Allow"
    "protocol"                   = "Tcp"
    "source_port_range"          = "*"
    "destination_port_range"     = "22"
    "source_address_prefix"      = "0.0.0.0"
    "destination_address_prefix" = "10.0.0.5"
  }
}

variable "vmNICPrivateIP" {
  type        = string
  description = "virtual machine network interface private IP address"
  default     = "10.0.0.5"
}

variable "vmPublicIPDNS" {
  type        = string
  description = "virtual machine public IP DNS name"
  default     = "ansibledevhost1"
}

variable "vmName" {
  type        = string
  description = "virtual machine name"
  default     = "ansibledevhost1"
}

variable "vmSize" {
  type        = string
  description = "virtual machine size"
  default     = "Standard_B2s"
}

variable "vmAdminName" {
  type        = string
  description = "virtual machine admin name"
  default     = "ansibleadmin"
}

variable "vmSrcImageReference" {
  type        = map
  description = "virtual machine source image reference"
  default = {
    "publisher" = "Canonical"
    "offer"     = "UbuntuServer"
    "sku"       = "18.04-LTS"
    "version"   = "latest"
  }
}

variable "vmShutdownTime" {
  type        = string
  description = "virtual machine daily shutdown time"
  default     = "1900"
}

variable "vmShutdownTimeZone" {
  type        = string
  description = "virtual machine daily shutdown time zone"
  default     = "AUS Eastern Standard Time"
}
