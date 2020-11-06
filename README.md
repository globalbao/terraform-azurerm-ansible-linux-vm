# AzureRM Ansible Linux VM - 
A custom Terraform module to deploy 1x Linux VM for Ansible playbook development in Microsoft Azure.

## Pre-requisities
* Terraform > 0.13.0
* Git
* VSCode
* VSCode (extension) Remote SSH
* VSCode (extension) Remote - SSH: Editing Configuration Files
* AzureCLI

## Input Variables

* `technician_initials` via Terraform CLI prompt -- Enter your initials (used as a suffix identifier for key Azure resources)
* `module.linux_vm.nsgRule1.source_address_prefix` via ./main.tf -- Update with your own public IP address

## Outputs

* `module.linux_vm.pip1` - The public IP DNS of the ansible host in azure
* `module.linux_vm.tls_private_key`- The SSH private key needed to connect to the ansible host in azure
* `module.linux_vm.azurerm_resource_group_name` - The resource group for the ansible dev environment
* `module.linux_vm.azurerm_virtual_network_name`- The virtual network name for the ansible dev environment


## Example Usage for Windows Users

* Clone this repo
```
git clone https://github.com/globalbao/terraform-azurerm-ansible-linux-vm
```

* Initialize the module
```
cd terraform-azurerm-ansible-linux-vm
terraform init
```
* Modify this variable in `/terraform-azurerm-ansible-linux-vm/main.tf`
	* module.linux_vm.nsgRule1.`source_address_prefix`

* Authenticate to Azure
```
az logout
az login
az account list
az account set -s subscriptionID
az account show
```

* Run Terraform to create the module resources
```
terraform apply -auto-approve
```

* Create a new local file for the private key e.g. `C:\Local\vm1key.pem`
	* Modify the file's permissions so only your Windows account has read/write access. Remove all other inherited permissions e.g. System/Administrator Group.
	* Copy & Paste the Terraform output of `tls_private_key` into this new file.

* VSCode > Remote Explorer > SSH Targets > Add New
	* Copy & Paste the Terraform output of `pip1` as the SSH target.
	* Select the SSH config file to update e.g. `C:\Users\Username\.ssh\config`
	* Add the following to SSH config file
		* `User ansibleadmin`
		* `IdentityFile C:/Local/vm1key.pem`

* Test the SSH connection to the target works.
