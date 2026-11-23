terraform {
  required_version = ">= 1.5.0"

  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "1.10.3"
    }
  }
}

resource "esxi_vswitch" "lab" {
  name             = var.vswitch_name
  ports            = var.vswitch_ports
  mtu              = var.vswitch_mtu
  promiscuous_mode = var.clusterxl_promiscuous_mode
  mac_changes      = var.clusterxl_mac_changes
  forged_transmits = var.clusterxl_forged_transmits

  dynamic "uplink" {
    for_each = var.vswitch_uplinks
    content {
      name = uplink.value
    }
  }
}

resource "esxi_portgroup" "internal" {
  name             = var.internal_portgroup_name
  vswitch          = esxi_vswitch.lab.name
  vlan             = var.vlan_internal_id
  promiscuous_mode = var.clusterxl_promiscuous_mode
  mac_changes      = var.clusterxl_mac_changes
  forged_transmits = var.clusterxl_forged_transmits
}

resource "esxi_portgroup" "sync" {
  name             = var.sync_portgroup_name
  vswitch          = esxi_vswitch.lab.name
  vlan             = var.vlan_sync_id
  promiscuous_mode = var.clusterxl_promiscuous_mode
  mac_changes      = var.clusterxl_mac_changes
  forged_transmits = var.clusterxl_forged_transmits
}

resource "esxi_portgroup" "external" {
  count = var.enable_wan_segment ? 1 : 0

  name             = var.external_portgroup_name
  vswitch          = esxi_vswitch.lab.name
  vlan             = var.vlan_external_id
  promiscuous_mode = var.clusterxl_promiscuous_mode
  mac_changes      = var.clusterxl_mac_changes
  forged_transmits = var.clusterxl_forged_transmits
}
