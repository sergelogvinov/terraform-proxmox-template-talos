
variable "node" {
  description = "Proxmox node name where VM template will be created"
  type        = string
}

variable "datastore" {
  description = "Datastore to store the Talos image"
  type        = string
  default     = "local"
}

variable "template_name" {
  description = "Name of the Talos template VM"
  type        = string
  default     = "talos"
}

variable "template_pool" {
  description = "Name of the Talos template VM pool"
  type        = string
  default     = ""
}

variable "template_tpm" {
  description = "Whether to enable TPM for the Talos template VM"
  type        = bool
  default     = false
}

variable "template_id" {
  description = "ID of the Talos template VM"
  type        = number
}

variable "template_datastore" {
  description = "Datastore to store the Talos template"
  type        = string
  default     = "local"
}

variable "template_network" {
  type = map(any)
  default = {
    "vmbr0" = {
      # firewall = false
      # ip6      = "auto"
      # gw6      = "fe80::1"
      # ip4      = "dhcp"
      # gw4      = "192.168.1.1"
    }
  }
}

variable "template_network_dns" {
  type    = list(string)
  default = []
}

variable "talos_version" {
  description = "Version of Talos of template to download"
  type        = string
  default     = "v1.12.1"
}

variable "talos_factory_hash" {
  description = "Hash of the Talos factory image to download"
  type        = string
  default     = "376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba"
}

variable "talos_secureboot" {
  description = "Whether to use the secureboot Talos image"
  type        = bool
  default     = false
}

variable "talos_image_name" {
  description = "Name of the Talos image to download"
  type        = string
  default     = "talos.raw.xz.img"
}

variable "tags" {
  description = "Tags to be applied to the VM"
  type        = list(string)
  default     = ["talos"]
}
