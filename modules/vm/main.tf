terraform {
  required_version = ">= 1.5.0"

  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "1.10.3"
    }
  }
}

resource "esxi_guest" "this" {
  guest_name     = var.guest_name
  disk_store     = var.disk_store
  guestos        = var.guestos
  boot_disk_type = var.boot_disk_type
  boot_disk_size = var.boot_disk_size
  memsize        = var.memsize
  numvcpus       = var.numvcpus
  virthwver      = var.virthwver
  boot_firmware  = var.boot_firmware
  power          = var.power
  notes          = var.notes
  ovf_source     = var.ovf_source != "" ? var.ovf_source : null

  dynamic "network_interfaces" {
    for_each = var.network_interfaces
    content {
      virtual_network = network_interfaces.value.virtual_network
      nic_type        = network_interfaces.value.nic_type
      mac_address     = try(network_interfaces.value.mac_address, null)
    }
  }
}
