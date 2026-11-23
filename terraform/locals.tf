locals {
  fw_base_nics = [
    {
      virtual_network = var.mgmt_portgroup_name
      nic_type        = "vmxnet3"
    },
    {
      virtual_network = module.network.internal_portgroup_name
      nic_type        = "vmxnet3"
    },
    {
      virtual_network = module.network.sync_portgroup_name
      nic_type        = "vmxnet3"
    }
  ]

  fw_wan_nic = var.enable_wan_segment ? [
    {
      virtual_network = module.network.external_portgroup_name
      nic_type        = "vmxnet3"
    }
  ] : []

  fw_nics = concat(local.fw_base_nics, local.fw_wan_nic)

  vms = {
    fw1 = {
      guest_name    = var.vm_names.fw1
      guestos       = var.checkpoint_guestos
      boot_firmware = "bios"
      ovf_source    = var.checkpoint_fw_ova_path
      notes         = "Check Point Security Gateway - ClusterXL Member 1"
      nics          = local.fw_nics
    }
    fw2 = {
      guest_name    = var.vm_names.fw2
      guestos       = var.checkpoint_guestos
      boot_firmware = "bios"
      ovf_source    = var.checkpoint_fw_ova_path
      notes         = "Check Point Security Gateway - ClusterXL Member 2"
      nics          = local.fw_nics
    }
    sms = {
      guest_name    = var.vm_names.sms
      guestos       = var.checkpoint_guestos
      boot_firmware = "bios"
      ovf_source    = var.checkpoint_sms_ova_path
      notes         = "Check Point Security Management Server"
      nics = [
        {
          virtual_network = module.network.internal_portgroup_name
          nic_type        = "vmxnet3"
        }
      ]
    }
    winserv = {
      guest_name    = var.vm_names.winserv
      guestos       = var.windows_server_guestos
      boot_firmware = var.windows_boot_firmware
      ovf_source    = ""
      notes         = "Windows Server - AD DS / LDAP / DNS / DHCP / AD CS"
      nics = [
        {
          virtual_network = module.network.internal_portgroup_name
          nic_type        = "vmxnet3"
        }
      ]
    }
    winclient = {
      guest_name    = var.vm_names.winclient
      guestos       = var.windows_client_guestos
      boot_firmware = var.windows_boot_firmware
      ovf_source    = ""
      notes         = "Windows Client - Lab Workstation"
      nics = [
        {
          virtual_network = module.network.internal_portgroup_name
          nic_type        = "vmxnet3"
        }
      ]
    }
  }
}
