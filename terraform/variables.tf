# -----------------------------------------------------------------------------
# Conexao ESXi Standalone (sem vCenter)
# -----------------------------------------------------------------------------
variable "esxi_hostname" {
  description = "IP ou FQDN de gerenciamento do host ESXi 6.5 standalone."
  type        = string
}

variable "esxi_ssh_port" {
  description = "Porta SSH do ESXi (restrita a rede de gerenciamento)."
  type        = string
  default     = "22"
}

variable "esxi_ssl_port" {
  description = "Porta HTTPS/SSL do ESXi."
  type        = string
  default     = "443"
}

variable "esxi_username" {
  description = "Usuario administrativo do ESXi (ex.: root)."
  type        = string
  sensitive   = true
}

variable "esxi_password" {
  description = "Senha do usuario administrativo do ESXi (nao versionar em Git)."
  type        = string
  sensitive   = true
}

variable "esxi_datastore" {
  description = "Nome exato do datastore no ESXi (ex.: datastore1)."
  type        = string
}

# -----------------------------------------------------------------------------
# Redes VMware (Standard vSwitch & Port Groups)
# -----------------------------------------------------------------------------
variable "mgmt_portgroup_name" {
  description = "Nome exato do Port Group de gerenciamento existente no ESXi (nao sera modificado)."
  type        = string
}

variable "lab_vswitch_name" {
  description = "Nome do novo Standard vSwitch criado para o laboratorio."
  type        = string
  default     = "vSwitch_LAB_CP"
}

variable "lab_vswitch_uplinks" {
  description = "Uplinks fisicos opcionais para o novo vSwitch (vazio = vSwitch isolado/interno)."
  type        = list(string)
  default     = []
}

variable "internal_portgroup_name" {
  description = "Nome do Port Group da rede interna."
  type        = string
  default     = "VLAN_INTERNAL"
}

variable "vlan_internal_id" {
  description = "VLAN ID do Port Group VLAN_INTERNAL (0 para sem tag)."
  type        = number
}

variable "sync_portgroup_name" {
  description = "Nome do Port Group da rede Sync do ClusterXL."
  type        = string
  default     = "VLAN_SYNC"
}

variable "vlan_sync_id" {
  description = "VLAN ID do Port Group VLAN_SYNC (0 para sem tag)."
  type        = number
}

variable "enable_wan_segment" {
  description = "Criar Port Group WAN/External opcional e adicionar eth3 em FW1/FW2 (false por padrao; requer aprovacao)."
  type        = bool
  default     = false
}

variable "external_portgroup_name" {
  description = "Nome do Port Group WAN/External opcional."
  type        = string
  default     = "VLAN_EXTERNAL"
}

variable "vlan_external_id" {
  description = "VLAN ID opcional para VLAN_EXTERNAL."
  type        = number
  default     = 0
}

# -----------------------------------------------------------------------------
# Dimensionamento de Hardware Virtual (ESXi 6.5)
# -----------------------------------------------------------------------------
variable "vm_vcpus" {
  description = "Numero de vCPUs por VM (configuravel, padrao 2)."
  type        = number
  default     = 2
}

variable "vm_ram_mb" {
  description = "Memoria RAM por VM em MB (padrao 8192 = 8 GB)."
  type        = number
  default     = 8192
}

variable "vm_disk_gb" {
  description = "Tamanho do disco virtual por VM em GB (padrao 200)."
  type        = number
  default     = 200
}

variable "vm_disk_type" {
  description = "Tipo de disco virtual (thin, thick, eagerZeroedThick)."
  type        = string
  default     = "thin"
}

variable "vm_hw_version" {
  description = "Versao de hardware virtual ESXi (13 = ESXi 6.5)."
  type        = string
  default     = "13"
}

variable "vm_initial_power" {
  description = "Estado inicial das VMs apos criacao (off permite anexar ISOs antes do primeiro boot)."
  type        = string
  default     = "off"
}

variable "vm_names" {
  description = "Mapeamento dos nomes das VMs exibidos no VMware ESXi."
  type = object({
    fw1       = string
    fw2       = string
    sms       = string
    winserv   = string
    winclient = string
  })
  default = {
    fw1       = "FW1"
    fw2       = "FW2"
    sms       = "SMS"
    winserv   = "WINSERV-LAB"
    winclient = "WIN-LAB"
  }
}

# -----------------------------------------------------------------------------
# Sistemas Operacionais, ISOs e OVAs
# -----------------------------------------------------------------------------
variable "checkpoint_guestos" {
  description = "Guest OS no ESXi para Gaia (rhel7-64 para R81.20)."
  type        = string
  default     = "rhel7-64"
}

variable "windows_server_guestos" {
  description = "Guest OS no ESXi para Windows Server (ex.: windows9srv-64)."
  type        = string
  default     = "windows9srv-64"
}

variable "windows_client_guestos" {
  description = "Guest OS no ESXi para Windows Client (ex.: windows9-64)."
  type        = string
  default     = "windows9-64"
}

variable "windows_boot_firmware" {
  description = "Firmware de boot para VMs Windows (bios ou efi)."
  type        = string
  default     = "efi"
}

variable "checkpoint_iso_path" {
  description = "Caminho da ISO Check Point Gaia no datastore (ex.: [datastore1] ISO/Check_Point_R81.20.iso)."
  type        = string
  default     = ""
}

variable "windows_server_iso_path" {
  description = "Caminho da ISO Windows Server no datastore (ex.: [datastore1] ISO/Windows_Server_2022.iso)."
  type        = string
  default     = ""
}

variable "windows_client_iso_path" {
  description = "Caminho da ISO Windows Client no datastore (ex.: [datastore1] ISO/Windows_11.iso)."
  type        = string
  default     = ""
}

variable "checkpoint_fw_ova_path" {
  description = "Opcional: caminho local de OVA para FW1/FW2 (requer ovftool; deixe vazio para usar ISO)."
  type        = string
  default     = ""
}

variable "checkpoint_sms_ova_path" {
  description = "Opcional: caminho local de OVA para SMS (requer ovftool; deixe vazio para usar ISO)."
  type        = string
  default     = ""
}
