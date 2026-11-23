variable "vswitch_name" {
  description = "Nome do novo Standard vSwitch no ESXi."
  type        = string
}

variable "vswitch_ports" {
  description = "Numero de portas do Standard vSwitch."
  type        = number
  default     = 128
}

variable "vswitch_mtu" {
  description = "MTU do Standard vSwitch."
  type        = number
  default     = 1500
}

variable "vswitch_uplinks" {
  description = "Lista opcional de uplinks fisicos (ex.: [\"vmnic1\"]). Vazio para vSwitch interno."
  type        = list(string)
  default     = []
}

variable "internal_portgroup_name" {
  description = "Nome do Port Group para a rede interna."
  type        = string
  default     = "VLAN_INTERNAL"
}

variable "vlan_internal_id" {
  description = "VLAN ID do Port Group VLAN_INTERNAL (0 para sem tag)."
  type        = number
}

variable "sync_portgroup_name" {
  description = "Nome do Port Group para a rede de sync do ClusterXL."
  type        = string
  default     = "VLAN_SYNC"
}

variable "vlan_sync_id" {
  description = "VLAN ID do Port Group VLAN_SYNC (0 para sem tag)."
  type        = number
}

variable "enable_wan_segment" {
  description = "Habilita criacao opcional do Port Group WAN/External (requer aprovacao)."
  type        = bool
  default     = false
}

variable "external_portgroup_name" {
  description = "Nome do Port Group opcional WAN/External."
  type        = string
  default     = "VLAN_EXTERNAL"
}

variable "vlan_external_id" {
  description = "VLAN ID opcional para VLAN_EXTERNAL."
  type        = number
  default     = 0
}

variable "clusterxl_promiscuous_mode" {
  description = "Aceitar Promiscuous Mode (obrigatorio para ClusterXL VMAC/CCP)."
  type        = bool
  default     = true
}

variable "clusterxl_mac_changes" {
  description = "Aceitar MAC Address Changes (obrigatorio para ClusterXL)."
  type        = bool
  default     = true
}

variable "clusterxl_forged_transmits" {
  description = "Aceitar Forged Transmits (obrigatorio para ClusterXL)."
  type        = bool
  default     = true
}
