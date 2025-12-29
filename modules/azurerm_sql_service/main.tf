############################
# KEY VAULT DATA
############################

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

############################
# SQL SERVER
############################

resource "azurerm_mssql_server" "this" {
  name                = lower(var.sql_server_name)
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = "12.0"

  administrator_login          = data.azurerm_key_vault_secret.admin_username.value
  administrator_login_password = data.azurerm_key_vault_secret.admin_password.value

  tags = var.tags
}

############################
# SQL DATABASE
############################

resource "azurerm_mssql_database" "this" {
  name      = var.database_name
  server_id = azurerm_mssql_server.this.id
  sku_name  = var.database_sku

  tags = var.tags
}

############################
# SQL FIREWALL RULE
############################

resource "azurerm_mssql_firewall_rule" "allow_ip" {
  name             = "allow-client-ip"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = var.allowed_ip
  end_ip_address   = var.allowed_ip
}
