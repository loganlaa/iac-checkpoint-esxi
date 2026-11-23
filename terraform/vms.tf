module "vm" {
  source   = "../modules/vm"
  for_each = local.vms

  guest_name         = each.value.guest_name
  disk_store         = var.esxi_datastore
  guestos            = each.value.guestos
  boot_disk_type     = var.vm_disk_type
  boot_disk_size     = var.vm_disk_gb
  memsize            = var.vm_ram_mb
  numvcpus           = var.vm_vcpus
  virthwver          = var.vm_hw_version
  boot_firmware      = each.value.boot_firmware
  power              = var.vm_initial_power
  ovf_source         = each.value.ovf_source
  notes              = each.value.notes
  network_interfaces = each.value.nics

  depends_on = [module.network]
}
