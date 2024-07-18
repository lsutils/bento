To build a Ubuntu 22.04 box for only the VirtualBox provider

```bash
cd <path/to>/bento
packer init -upgrade ./packer_templates
packer build -only=virtualbox-iso.vm -var-file=os_pkrvars/ubuntu/ubuntu-22.04-x86_64.pkrvars.hcl ./packer_templates
```

To build latest Debian 12 boxes for all possible providers (simultaneously)
