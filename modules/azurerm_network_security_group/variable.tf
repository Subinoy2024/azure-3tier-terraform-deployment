variable "nsgs" {
  description = "Map of Network Security Groups"
  type = map(object({
    location            = string
    resource_group_name = string
    tags                = map(string)
  }))
}

variable "nsg_rules" {
  description = "Flattened map of NSG rules"
  type = map(object({
    nsg_name                    = string
    rule_name                   = string
    priority                    = number
    direction                   = string
    access                      = string
    protocol                    = string
    source_port_range           = string
    destination_port_range      = string
    source_address_prefix       = string
    destination_address_prefix  = string
    resource_group_name         = string
  }))
}
