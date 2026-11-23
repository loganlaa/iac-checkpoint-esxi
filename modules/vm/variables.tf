variable "guest_name" {
  description = "Nome da VM e hostname de identificacao no ESXi."
  type        = string
}

variable "disk_store" {
  description = "Nome do datastore ESXi onde os arquivos da VM serao criados."
  type        = string
}

variable "guestos" {
  description = "Identificador de Guest OS no ESXi (ex.: rhel7-64, windows9srv-64, windows9-64)."
  type        = string
}

variable "boot_disk_type" {
  description = "Tipo de provisionamento de disco (thin, thick, eagerZeroedThick)."
  type        = string
  default     = "thin"
}

variable "boot_disk_size" {
  description = "Tamanho do disco de boot em GB."
  type        = number
  default     = 200
}

variable "memsize" {
  description = "Memoria RAM em MB."
  type        = number
  default     = 8192
}

variable "numvcpus" {
  description = "Quantidade de vCPUs."
  type        = number
  default     = 2
}

variable "virthwver" {
  description = "Versao de hardware virtual compativel com ESXi 6.5 (13 = ESXi 6.5)."
  type        = string
  default     = "13"
}

variable "boot_firmware" {
  description = "Firmware de boot da VM (bios ou efi)."
  type        = string
  default     = "bios"
}

variable "power" {
  description = "Estado de energia inicial da VM (on ou off)."
  type        = string
  default     = "off"
}

variable "ovf_source" {
  description = "Caminho opcional de OVA/OVF local caso nao utilize instalacao via ISO."
  type        = string
  default     = ""
}

variable "notes" {
  description = "Anotacoes descritivas da VM no ESXi."
  type        = string
  default     = ""
}

variable "network_interfaces" {
  description = "Lista ordenada de interfaces de rede da VM."
  type = list(object({
    virtual_network = string
    nic_type        = string
    mac_address     = optional(string)
  }))
}
