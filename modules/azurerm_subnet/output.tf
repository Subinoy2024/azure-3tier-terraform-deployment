output "ids" {
  description = "Subnet IDs"
  value = {
    for k, s in azurerm_subnet.this :
    k => s.id
  }
}

output "names" {
  description = "Subnet names"
  value = {
    for k, s in azurerm_subnet.this :
    k => s.name
  }
}

output "address_prefixes" {
  description = "Subnet CIDRs"
  value = {
    for k, s in azurerm_subnet.this :
    k => s.address_prefixes
  }
}
