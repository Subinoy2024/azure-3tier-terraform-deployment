variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "bastion_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  description = "Must be AzureBastionSubnet"
  type        = string
}

variable "public_ip_id" {
  description = "Public IP ID for Bastion"
  type        = string
}

variable "sku" {
  description = "Basic or Standard"
  type        = string
  default     = "Standard"
}

variable "tags" {
  type = map(string)
}
