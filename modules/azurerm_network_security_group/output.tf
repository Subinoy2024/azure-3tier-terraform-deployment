output "ids" {
  value = {
    for k, nsg in azurerm_network_security_group.this :
    k => nsg.id
  }
}

output "names" {
  value = {
    for k, nsg in azurerm_network_security_group.this :
    k => nsg.name
  }
}
