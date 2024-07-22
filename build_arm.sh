brew tap hashicorp/tap
brew update
brew install --cask hashicorp/tap/hashicorp-vagrant
brew reinstall --cask virtualbox@beta

packer build -only=virtualbox-iso.vm -var-file=os_pkrvars/ubuntu/ubuntu-24.04-x86_64.pkrvars.hcl ./packer_templates

packer build -only=virtualbox-iso.vm -var-file=os_pkrvars/ubuntu/ubuntu-24.04-aarch64.pkrvars.hcl ./packer_templates
