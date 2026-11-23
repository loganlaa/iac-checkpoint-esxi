output "vswitch_name" {
  description = "Standard vSwitch criado no ESXi."
  value       = module.network.vswitch_name
}

output "portgroups" {
  description = "Port Groups criados para o laboratorio."
  value = {
    internal = module.network.internal_portgroup_name
    sync     = module.network.sync_portgroup_name
    external = module.network.external_portgroup_name
  }
}

output "vms" {
  description = "VMs provisionadas pelo Terraform."
  value = {
    for name, vm in module.vm : name => {
      id         = vm.id
      guest_name = vm.guest_name
      ip_address = vm.ip_address
    }
  }
}

output "iso_mapping" {
  description = "Mapeamento de ISOs para uso no script scripts/attach-iso.sh."
  value = {
    (var.vm_names.fw1)       = var.checkpoint_iso_path
    (var.vm_names.fw2)       = var.checkpoint_iso_path
    (var.vm_names.sms)       = var.checkpoint_iso_path
    (var.vm_names.winserv)   = var.windows_server_iso_path
    (var.vm_names.winclient) = var.windows_client_iso_path
  }
}
