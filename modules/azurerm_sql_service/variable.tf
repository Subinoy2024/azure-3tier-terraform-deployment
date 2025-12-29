variable "sql_server_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_sku" {
  type = string
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

variable "allowed_ip" {
  type = string
}

variable "tags" {
  type = map(string)
}
