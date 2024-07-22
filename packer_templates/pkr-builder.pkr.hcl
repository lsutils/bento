packer {
  required_version = ">= 1.7.0"
  required_plugins {
    vagrant = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vagrant"
    }
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

locals {
  scripts = [
    "${path.root}/scripts/${var.os_name}/update_${var.os_name}.sh",
    "${path.root}/scripts/_common/motd.sh",
    "${path.root}/scripts/_common/sshd.sh",
    "${path.root}/scripts/${var.os_name}/networking_${var.os_name}.sh",
    "${path.root}/scripts/${var.os_name}/sudoers_${var.os_name}.sh",
    "${path.root}/scripts/_common/vagrant.sh",
    "${path.root}/scripts/${var.os_name}/systemd_${var.os_name}.sh",
    "${path.root}/scripts/_common/virtualbox.sh",
    "${path.root}/scripts/_common/vmware_debian_ubuntu.sh",
    "${path.root}/scripts/_common/parallels.sh",
    "${path.root}/scripts/${var.os_name}/hyperv_${var.os_name}.sh",
    "${path.root}/scripts/${var.os_name}/cleanup_${var.os_name}.sh",
    "${path.root}/scripts/_common/parallels_post_cleanup_debian_ubuntu.sh",
    "${path.root}/scripts/_common/minimize.sh",
    "${path.root}/scripts/_common/custom-script-ubuntu22.04.sh"
  ]
  source_names = [for source in var.sources_enabled : trimprefix(source, "source.")]
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = var.sources_enabled

  # Linux Shell scipts
  provisioner "shell" {
    environment_vars = var.os_name == "freebsd" ? [
      "HOME_DIR=/home/vagrant",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}",
      "pkg_branch=quarterly"
      ] : (
      var.os_name == "solaris" ? [] : [
        "HOME_DIR=/home/vagrant",
        "http_proxy=${var.http_proxy}",
        "https_proxy=${var.https_proxy}",
        "no_proxy=${var.no_proxy}"
      ]
    )
    execute_command = var.os_name == "freebsd" ? "echo 'vagrant' | {{.Vars}} su -m root -c 'sh -eux {{.Path}}'" : (
      var.os_name == "solaris" ? "echo 'vagrant'|sudo -S bash {{.Path}}" : "echo 'vagrant' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    )
    expect_disconnect = true
    scripts           = local.scripts
    except            = var.is_windows ? local.source_names : null
  }

  # Convert machines to vagrant boxes
  post-processor "vagrant" {
    compression_level = 9
    output            = "${path.root}/../builds/${var.os_name}-${var.os_version}-${var.os_arch}.{{ .Provider }}.box"
    vagrantfile_template = "${path.root}/vagrantfile-freebsd.template"
  }
}
