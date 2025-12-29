variable "vms" {
  type = map(object({
    vm_name   = string
    location  = string
    rg_name   = string
    size      = string

    subnet_id = string
    pip_id    = optional(string)

    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })

    tags = map(string)
  }))
}

variable "key_vault_name" {
  type = string
}

variable "key_vault_rg" {
  type = string
}

variable "admin_username_secret_name" {
  type = string
}

variable "admin_password_secret_name" {
  type = string
}
