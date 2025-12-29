variable "subnet_nsg_associations" {
  description = "Map of subnet to NSG associations"
  type = map(object({
    subnet_id = string
    nsg_id    = string
  }))
}
