output "ids" {
  description = "Public IP IDs"
  value = {
    for k, pip in azurerm_public_ip.this :
    k => pip.id
  }
}

output "ip_addresses" {
  description = "Allocated public IP addresses"
  value = {
    for k, pip in azurerm_public_ip.this :
    k => pip.ip_address
  }
}

output "names" {
  description = "Public IP names"
  value = {
    for k, pip in azurerm_public_ip.this :
    k => pip.name
  }
}
