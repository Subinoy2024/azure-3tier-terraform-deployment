data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "Set",
      "List",
      "Delete",
      "Purge",
      "Recover",
      "Restore",
    ]

    storage_permissions = [
      "Get",
    ]
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "this" {
  for_each = var.secrets
  depends_on = [ azurerm_key_vault.this ]

  # Map key is the secret name (already valid)
  name  = lower(replace(each.key, "_", "-"))
  value = each.value.value

  key_vault_id = azurerm_key_vault.this.id
}
