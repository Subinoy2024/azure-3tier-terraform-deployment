output "association_ids" {
  description = "IDs of subnet-NSG associations"
  value = {
    for k, assoc in azurerm_subnet_network_security_group_association.this :
    k => assoc.id
  }
}
