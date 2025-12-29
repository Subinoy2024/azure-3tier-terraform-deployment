variable "subnets" {
  description = "Map of subnet definitions"
  type = map(object({
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)

    service_endpoints = optional(list(string), [])
    delegations = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })), [])
  }))
}
