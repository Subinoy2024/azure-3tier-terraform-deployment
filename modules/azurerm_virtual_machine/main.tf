data "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}
data "azurerm_key_vault_secret" "admin_username" {
  name         = var.admin_username_secret_name
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = var.admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.this.id
}
resource "azurerm_network_interface" "this" {
  for_each = var.vms

  name                = "${each.key}-nic"
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = try(each.value.pip_id, null)
  }

  tags = each.value.tags
}
resource "azurerm_linux_virtual_machine" "this" {
  for_each = var.vms

  name                = each.value.vm_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  size                = each.value.size

  admin_username = data.azurerm_key_vault_secret.admin_username.value
  admin_password = data.azurerm_key_vault_secret.admin_password.value

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.this[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  tags = each.value.tags
}
