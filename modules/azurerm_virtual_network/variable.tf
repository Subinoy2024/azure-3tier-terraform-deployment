variable "vnets" {
  description = "Map of virtual networks"
  type = map(object({
    resource_group_name = string
    location            = string
    address_space       = list(string)
    tags                = map(string)
  }))
}
