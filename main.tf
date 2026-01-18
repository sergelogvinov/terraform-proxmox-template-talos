
resource "proxmox_virtual_environment_download_file" "talos" {
  node_name    = var.node
  content_type = "iso"
  datastore_id = var.datastore
  file_name    = var.talos_image_name
  overwrite    = false

  decompression_algorithm = "zst"
  url                     = "https://factory.talos.dev/image/${var.talos_factory_hash}/${var.talos_version}/nocloud-amd64${var.talos_secureboot ? "-secureboot" : ""}.raw.xz"
}

resource "proxmox_virtual_environment_file" "userdata" {
  count        = length(var.template_userdata) > 0 ? 1 : 0
  node_name    = var.node
  content_type = "snippets"
  datastore_id = var.datastore

  source_raw {
    data      = var.template_userdata
    file_name = "${var.template_name}.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "template" {
  name        = var.template_name
  node_name   = var.node
  vm_id       = var.template_id
  pool_id     = var.template_pool != "" ? var.template_pool : null
  on_boot     = false
  template    = true
  description = "Talos template version ${var.talos_version}"
  tags        = var.tags

  bios = "ovmf"
  efi_disk {
    datastore_id = var.template_datastore
    type         = "4m"
  }

  dynamic "tpm_state" {
    for_each = var.template_tpm ? [1] : []
    content {
      datastore_id = var.template_datastore
      version      = "v2.0"
    }
  }

  operating_system {
    type = "l26"
  }

  machine = "q35"
  cpu {
    architecture = "x86_64"
    cores        = 1
    sockets      = 1
    numa         = true
    type         = "host"
    flags        = sort(flatten([var.template_cpu_flags, var.template_hugepages == "1024" ? ["+pdpe1gb"] : []]))
  }
  dynamic "memory" {
    for_each = var.template_hugepages != "" ? [1] : []
    content {
      dedicated = 1024
      floating  = 0
      hugepages = var.template_hugepages
      # Kernel may not allocate memory if hugepages are released, so we keep them allocated
      # Better to allocate 1G hugepages on boot time, kernel cmdline: default_hugepagesz=1G hugepagesz=1G hugepages=xx
      keep_hugepages = var.template_hugepages == "1024" ? true : false
    }
  }

  scsi_hardware = "virtio-scsi-single"
  disk {
    file_id      = proxmox_virtual_environment_download_file.talos.id
    datastore_id = var.template_datastore
    interface    = "scsi0"
    ssd          = true
    iothread     = true
    cache        = "none"
    size         = 6
    file_format  = "raw"
  }

  dynamic "network_device" {
    for_each = var.template_network
    content {
      bridge   = network_device.key
      firewall = lookup(network_device.value, "firewall", false)
    }
  }

  initialization {
    dynamic "dns" {
      for_each = length(var.template_network_dns) > 0 ? [1] : []
      content {
        servers = var.template_network_dns
      }
    }

    dynamic "ip_config" {
      for_each = var.template_network
      content {
        dynamic "ipv4" {
          for_each = contains(keys(ip_config.value), "ip4") ? [1] : []
          content {
            address = lookup(ip_config.value, "ip4")
            gateway = lookup(ip_config.value, "gw4", null)
          }
        }
        dynamic "ipv6" {
          for_each = contains(keys(ip_config.value), "ip6") ? [1] : []
          content {
            address = lookup(ip_config.value, "ip6")
            gateway = lookup(ip_config.value, "gw6", null)
          }
        }
      }
    }

    datastore_id      = var.template_datastore
    user_data_file_id = length(proxmox_virtual_environment_file.userdata) > 0 ? proxmox_virtual_environment_file.userdata[0].id : null
  }

  tablet_device = false
  serial_device {}
  vga {
    type = "serial0"
  }

  lifecycle {
    ignore_changes = [
      network_interface_names,
    ]
  }
}
