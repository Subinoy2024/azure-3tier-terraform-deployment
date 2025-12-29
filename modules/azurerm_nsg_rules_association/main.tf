resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.subnet_nsg_associations

  subnet_id                 = each.value.subnet_id
  network_security_group_id = each.value.nsg_id

}
