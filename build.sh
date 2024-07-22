set -ex
packer plugins install github.com/hashicorp/vagrant
packer plugins install github.com/hashicorp/virtualbox


#packer init -upgrade ./packer_templates
rm -rf ./builds/*
rm -rf /Users/acejilam/VirtualBox\ VMs/*
packer build -only=virtualbox-iso.vm -var-file=os_pkrvars/ubuntu/ubuntu-22.04-x86_64.pkrvars.hcl ./packer_templates
