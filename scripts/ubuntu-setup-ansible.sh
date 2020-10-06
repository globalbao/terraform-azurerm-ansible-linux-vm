#!/bin/bash

# Update all packages that have available updates.
sudo apt-get update
sudo apt upgrade -y

# Install ansible developer requirements
pip3 install wheel --quiet
pip3 install pywinrm --quiet
pip3 install requests --quiet
pip3 install ansible --quiet
pip3 install ansible-lint --quiet
pip3 install ansible[azure] --quiet
pip3 install molecule --quiet
pip3 install molecule-azure --quiet
pip3 install junit_xml --quiet

# Install AzCLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash