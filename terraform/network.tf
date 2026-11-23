module "network" {
  source = "../modules/network"

  vswitch_name               = var.lab_vswitch_name
  vswitch_uplinks            = var.lab_vswitch_uplinks
  internal_portgroup_name    = var.internal_portgroup_name
  vlan_internal_id           = var.vlan_internal_id
  sync_portgroup_name        = var.sync_portgroup_name
  vlan_sync_id               = var.vlan_sync_id
  enable_wan_segment         = var.enable_wan_segment
  external_portgroup_name    = var.external_portgroup_name
  vlan_external_id           = var.vlan_external_id
  clusterxl_promiscuous_mode = true
  clusterxl_mac_changes      = true
  clusterxl_forged_transmits = true
}
