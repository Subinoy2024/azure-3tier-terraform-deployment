# output "ids" {
#   description = "Virtual Network IDs"
#   value = {
#     for k, v in azurerm_virtual_network.this :
#     k => v.id
#   }
# }

# output "names" {
#   description = "Virtual Network names"
#   value = {
#     for k, v in azurerm_virtual_network.this :
#     k => v.name
#   }
# }

# output "address_spaces" {
#   description = "VNet address spaces"
#   value = {
#     for k, v in azurerm_virtual_network.this :
#     k => v.address_space
#   }
# }
