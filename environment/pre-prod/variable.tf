variable "environment" {
  type = string
}
variable "country" {
  type = string
}
variable "location" {
  type = string
}

variable "admin_username" {
  description = "VM admin username"
  type        = string
  sensitive   = true
}

variable "vm_admin_password" {
  description = "VM admin password"
  type        = string
  sensitive   = true
}

variable "rbac_admin_password" {
  description = "rbac admin username"
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "SQL admin password"
  type        = string
  sensitive   = true
}
