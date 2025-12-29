output "key_vault_id" {
  value = azurerm_key_vault.this.id
}

output "secret_ids" {
  value = {
    for k, s in azurerm_key_vault_secret.this :
    k => s.id
  }
}
output "key_vault_name" {
  value = azurerm_key_vault.this.name
}

output "resource_group_name" {
  value = azurerm_key_vault.this.resource_group_name
}