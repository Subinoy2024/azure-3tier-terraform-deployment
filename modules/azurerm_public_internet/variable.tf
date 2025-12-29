variable "public_ips" {
  description = "Map of Azure Public IPs"
  type = map(object({
    location            = string
    resource_group_name = string
    allocation_method   = string   # Static | Dynamic
    sku                 = string   # Basic | Standard
    tags                = map(string)
  }))
}
