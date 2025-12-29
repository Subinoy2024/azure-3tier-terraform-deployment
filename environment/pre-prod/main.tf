module "resource_groups" {
  source          = "../../modules/azurerm_resource_group"
  resource_groups = local.resource_groups

}
resource "random_string" "sql_suffix" {
  length  = 4
  upper   = false
  special = false
  lower   = true
  numeric = true
}

module "vnets" {
  source     = "../../modules/azurerm_virtual_network"
  depends_on = [module.resource_groups]

  vnets = {
    for name, v in local.vnets :
    name => merge(

      v,
      {
        resource_group_name = module.resource_groups.names[v.resource_group_name]
      }
    )
  }
}



module "subnets" {
  depends_on = [module.vnets]
  source     = "../../modules/azurerm_subnet"
  subnets    = local.subnets
}

module "nsgs" {
  depends_on = [module.resource_groups, module.subnets, module.vnets]
  source     = "../../modules/azurerm_network_security_group"
  nsgs       = local.nsgs
  nsg_rules  = local.nsg_rules
}

module "nsg_associations" {
  depends_on = [module.vnets, module.subnets, module.nsgs]
  source     = "../../modules/azurerm_nsg_rules_association"

  subnet_nsg_associations = local.subnet_nsg_associations
}

module "public_ips" {
  depends_on = [module.vnets]
  source     = "../../modules/azurerm_public_internet"
  public_ips = local.public_ips
}

module "bastion" {
  depends_on = [module.subnets, module.vnets, module.resource_groups]
  source     = "../../modules/azurerm_bastion_service"

  location            = local.bastion.location
  resource_group_name = local.bastion.resource_group_name

  bastion_name = local.bastion.bastion_name
  vnet_name    = local.bastion.vnet_name
  subnet_name  = local.bastion.subnet_name

  public_ip_id = local.bastion.public_ip_id
  sku          = local.bastion.sku
  tags         = local.bastion.tags

}

module "key_vault" {
  source              = "../../modules/azurerm_key_vault"
  name                = "kv-${var.country}-${var.environment}-core-${random_string.sql_suffix.result}"
  location            = var.location
  resource_group_name = "rg-${var.country}-${var.environment}-core"

  secrets = local.azurerm_key_vault_secret
  tags    = local.common_tags

  depends_on = [
    module.resource_groups, module.vnets
  ]
}

module "linux_vms" {
  depends_on = [ module.resource_groups,module.public_ips,module.key_vault,module.vnets ]
  source = "../../modules/azurerm_virtual_machine"


  vms = local.vms

  key_vault_name = module.key_vault.key_vault_name
  key_vault_rg   = module.key_vault.resource_group_name

  admin_username_secret_name = "admin-username"
  admin_password_secret_name = "vm-admin-password"
}


module "sql" {
  
  source = "../../modules/azurerm_sql_service"

  sql_server_name     = local.sql.name
  resource_group_name = local.sql.resource_group_name
  location            = local.sql.location

  database_name = local.sql.database_name
  database_sku  = local.sql.database_sku

  key_vault_name = module.key_vault.key_vault_name
  key_vault_rg   = module.key_vault.resource_group_name

  admin_username_secret_name = local.sql.admin_username_secret_name
  admin_password_secret_name = local.sql.admin_password_secret_name

  allowed_ip = local.sql.allowed_ip
  tags       = local.sql.tags

  depends_on = [module.key_vault,module.resource_groups]
}

