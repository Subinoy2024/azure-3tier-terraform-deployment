resource "azurerm_network_security_group" "this" {
  for_each = var.nsgs

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = each.value.tags
}
resource "azurerm_network_security_rule" "this" {
  for_each = var.nsg_rules

  name                        = each.value.rule_name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix

  resource_group_name         = each.value.resource_group_name
  network_security_group_name = each.value.nsg_name
  depends_on = [
    azurerm_network_security_group.this
  ]
}
