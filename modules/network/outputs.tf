output "vswitch_name" {
  value = esxi_vswitch.lab.name
}

output "internal_portgroup_name" {
  value = esxi_portgroup.internal.name
}

output "sync_portgroup_name" {
  value = esxi_portgroup.sync.name
}

output "external_portgroup_name" {
  value = var.enable_wan_segment ? esxi_portgroup.external[0].name : null
}
