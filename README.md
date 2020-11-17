# AzureRM Ansible Linux VM
A custom Terraform module to deploy 1x Linux VM for Ansible playbook development in Microsoft Azure.

Get in touch :octocat:

* Twitter: [@coder_au](https://twitter.com/coder_au)
* LinkedIn: [@JesseLoudon](https://www.linkedin.com/in/jesseloudon/)
* Web: [jloudon.com](https://jloudon.com)
* GitHub: [@JesseLoudon](https://github.com/jesseloudon)

## Blogs that might interest you :pencil:

* [Ansible on Azure Part 1](https://jloudon.com/cloud/Ansible-on-Azure-Part-1/) covers the birds-eye solution overview and introduces you to key components.
* [Ansible on Azure Part 2](https://jloudon.com/cloud/Ansible-on-Azure-Part-2/) showcases this Terraform module used to automate deployment of an Ansible control host into Azure.
* [Ansible on Azure Part 3](https://jloudon.com/cloud/Ansible-on-Azure-Part-3/) dives into using the Molecule-Azure driver to rapidly develop Ansible playbook tasks on Azure instances.

## Terraform resources

Resource Type | Count | Notes
-------------:|:-----:|:------
Resource Group | 1 |Logical container for all below resources
Virtual Network | 1 |Provides network connectivity between the Ansible host & test instances
SSH Key| 1 |Your key authentication into the Ansible host (stored within the TF state file)
Linux Virtual Machine| 1 |Ubuntu server setup as the Ansible host
Public IP | 1|Allows remote connectivity into the Ansible host
Network Security Group| 1 |Restricts network access over SSH to the Ansible host from your defined Public IP
Virtual Machine Shutdown Schedule | 1 |Automatically shuts down the Ansible host on a daily schedule to save costs
Virtual Machine Extension | 1 |Automatically runs a shell script (located in the repo) to setup software requirements on the Ansible host

## Pre-requisities
* [Terraform > 0.13.0](https://www.terraform.io/downloads.html)
* [Git](https://git-scm.com/downloads)
* [VSCode](https://code.visualstudio.com/download)
* [VSCode (extension) Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
* [AzureCLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Input Variables

* `technician_initials` via Terraform CLI prompt -- Enter your initials (used as a suffix identifier for key Azure resources)
* `module.linux_vm.nsgRule1.source_address_prefix` via ./main.tf -- Update with your own public IP address

## Outputs

* `module.linux_vm.pip1` - The public IP DNS of the ansible host in azure
* `module.linux_vm.tls_private_key`- The SSH private key needed to connect to the ansible host in azure
* `module.linux_vm.azurerm_resource_group_name` - The resource group for the ansible dev environment
* `module.linux_vm.azurerm_virtual_network_name`- The virtual network name for the ansible dev environment

## Example Usage (Windows users)

* 1 - Clone the repo

```bash
git clone https://github.com/globalbao/terraform-azurerm-ansible-linux-vm
cd terraform-azurerm-ansible-linux-vm
```

* 2 - Initialize the module

```terraform
terraform init
```
* 3 - Set the value of `module.linux_vm.nsgRule1.source_address_prefix` to your own Public IP address.
* 4 - Authenticate to Azure via AzCLI

```bash
az login
az account set -s subscriptionID
```

* 5 - Run Terraform to create the module resources. 

```terraform
terraform apply -auto-approve
```

> the TF apply can take ~15mins due to the shell script tasks via VM Extension

At this stage your Ansible control host has been deployed to Azure and is ready for your SSH connection using VSCode.

Remember to take note of the following outputs.

* `module.linux_vm.pip1` - the PIP DNS name of your Ansible control host
* `module.linux_vm.tls_private_key`- the SSH private key needed to connect to your Ansible control host
* `module.linux_vm.azurerm_resource_group_name` - the RG of your Ansible dev environment
* `module.linux_vm.azurerm_virtual_network_name`- the VNET name of the Ansible dev environment

Setup/test the SSH authentication.

* 6 - Create a new local file for the private key e.g. `C:\Local\vm1key.pem`
* 7 - Modify the `C:\Local\vm1key.pem` file's permissions so only your Windows account has read/write access. 
* 8 - Remove all other inherited permissions (e.g. System/Administrator Group) from `C:\Local\vm1key.pem`.
* 9 - Copy & paste the Terraform output of `tls_private_key` into this new file.
* 10 - Open `VSCode > Remote Explorer > SSH Targets > Add New`
* 11 - Copy & paste the Terraform output of `pip1` as the SSH target.
* 12 - Select the SSH config file to update e.g. `C:\Users\Username\.ssh\config`
* 13 - Add the following to SSH config file:`User ansibleadmin` and `IdentityFile C:/Local/vm1key.pem`
* 14 - Verify the SSH connection works via `VSCode > Remote Explorer > SSH Target > Connect to Host`

> the above steps 6-14 work on my Win10 machine but if you encounter issues I recommend reviewing the official doco here: [https://code.visualstudio.com/docs/remote/ssh](https://code.visualstudio.com/docs/remote/ssh)

* 15 - Work on your Ansible development.
* 16 - Remove the environment.

```terraform
terraform destroy -auto-approve
```