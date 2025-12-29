variable "name" {
  description = "Key Vault name"
  type        = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "secrets" {
  description = "Secrets to create in the Key Vault (key = secret name)"
  type = map(object({
    value = string
  }))
}

variable "tags" {
  type = map(string)
}
