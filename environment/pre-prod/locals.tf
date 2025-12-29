locals {
  common_tags = {
    Environment = var.environment
    Owner       = "DC_Crop"
    ManagedBy   = "DC_Cloud_Team"
    Country     = "India"
  }

  resource_groups = {
    "rg-${var.country}-${var.environment}-core" = {
      location = var.location
      tags     = local.common_tags
    }
  }
  key_vault = {
    "kv-${var.country}-${var.environment}-core-${random_string.sql_suffix.result}" = {
      location                    = var.location
      resource_group_name         = "rg-${var.country}-${var.environment}-core"
      name                        = "kv-${var.country}-${var.environment}-core-${random_string.sql_suffix.result}"
      enabled_for_disk_encryption = true

    }
  }
  azurerm_key_vault_secret = {
    "admin-username" = {
      value = var.admin_username
    }

    "vm-admin-password" = {
      value = var.vm_admin_password
    }

    "sql-admin-password" = {
      value = var.sql_admin_password
    }
    "rbac-admin-password" = {
      value = var.rbac_admin_password
    }
  }

  vnets = {
    "vnet-${var.country}-${var.environment}-core" = {
      resource_group_name = "rg-${var.country}-${var.environment}-core"
      location            = var.location
      address_space       = ["172.168.10.0/24"]
      tags                = local.common_tags
    }
  }

  subnets = {
    "sub01-${var.country}-${var.environment}-frontend" = {
      resource_group_name  = "rg-${var.country}-${var.environment}-core"
      virtual_network_name = "vnet-${var.country}-${var.environment}-core"
      address_prefixes     = ["172.168.10.128/25"]

      #service_endpoints = ["Microsoft.Storage"]
    }

    "sub02-${var.country}-${var.environment}-backend" = {
      resource_group_name  = "rg-${var.country}-${var.environment}-core"
      virtual_network_name = "vnet-${var.country}-${var.environment}-core" 
      address_prefixes     = ["172.168.10.64/26"]
      #service_endpoints    = []
    }
    "AzureBastionSubnet" = {
      resource_group_name  = "rg-${var.country}-${var.environment}-core"
      virtual_network_name = "vnet-${var.country}-${var.environment}-core"
      address_prefixes     = ["172.168.10.0/26"]
      #service_endpoints    = []
    }
  }

  nsgs = {
    "nsg-${var.country}-${var.environment}-LinuxServer" = {
      location            = var.location
      resource_group_name = "rg-${var.country}-${var.environment}-core"
      tags                = local.common_tags
    }

  }

  nsg_rules = {
    "nsg-${var.country}-${var.environment}-app-allow-ssh" = {
      nsg_name                   = "nsg-${var.country}-${var.environment}-LinuxServer"
      rule_name                  = "allow-ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      resource_group_name        = "rg-${var.country}-${var.environment}-core"
    }

    "nsg-${var.country}-${var.environment}-app-allow-http" = {
      nsg_name                   = "nsg-${var.country}-${var.environment}-LinuxServer"
      rule_name                  = "allow-http"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      resource_group_name        = "rg-${var.country}-${var.environment}-core"
    }
    "nsg-${var.country}-${var.environment}-app-allow-https" = {
      nsg_name                   = "nsg-${var.country}-${var.environment}-LinuxServer"
      rule_name                  = "allow-https"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      resource_group_name        = "rg-${var.country}-${var.environment}-core"
    }

  }

  public_ips = {
    "pip1-${var.country}-${var.environment}-bastion" = {
      location            = var.location
      resource_group_name = "rg-${var.country}-${var.environment}-core"
      allocation_method   = "Static"
      sku                 = "Standard"
      tags                = local.common_tags
    }
    "pip2-${var.country}-${var.environment}-vm01" = {
      location            = var.location
      resource_group_name = "rg-${var.country}-${var.environment}-core"
      allocation_method   = "Static"
      sku                 = "Standard"
      tags                = local.common_tags
    }
    # "pip3-${var.country}-${var.environment}-lb" = {
    #   location            = var.location
    #   resource_group_name = "rg-${var.country}-${var.environment}-core"
    #   allocation_method   = "Static"
    #   sku                 = "Standard"
    #   tags                = local.common_tags
    # }
    # "pip4-${var.country}-${var.environment}-vm02" = {
    #   location            = var.location
    #   resource_group_name = "rg-${var.country}-${var.environment}-core"
    #   allocation_method   = "Static"
    #   sku                 = "Standard"
    #   tags                = local.common_tags
    # }
  }

  subnet_nsg_associations = {
    "linuxServer-subnet-nsg" = {
      subnet_id = module.subnets.ids["sub01-${var.country}-${var.environment}-frontend"]
      nsg_id    = module.nsgs.ids["nsg-${var.country}-${var.environment}-LinuxServer"]

    }
    "linuxServer-subnet-nsg2" = {
      subnet_id = module.subnets.ids["sub02-${var.country}-${var.environment}-backend"]
      nsg_id    = module.nsgs.ids["nsg-${var.country}-${var.environment}-LinuxServer"]

    }

  }
  bastion = {
    location            = var.location
    resource_group_name = "rg-${var.country}-${var.environment}-core"

    bastion_name = "bastion-${var.country}-${var.environment}"
    vnet_name    = "vnet-${var.country}-${var.environment}-core"

    # Must exist already as AzureBastionSubnet
    subnet_name = "AzureBastionSubnet"

    public_ip_id = module.public_ips.ids["pip1-${var.country}-${var.environment}-bastion"]

    sku  = "Standard"
    tags = local.common_tags
  }
  vms = {
    frontend = {
      vm_name  = "vm-${var.country}-${var.environment}-frontend"
      location = var.location
      rg_name  = "rg-${var.country}-${var.environment}-core"

      subnet_id = module.subnets.ids["sub01-${var.country}-${var.environment}-frontend"]
      pip_id    = module.public_ips.ids["pip2-${var.country}-${var.environment}-vm01"]

      size = "Standard_B2s"

      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }

      tags = local.common_tags
    }
    backend = {
      vm_name  = "vm-${var.country}-${var.environment}-backend"
      location = var.location
      rg_name  = "rg-${var.country}-${var.environment}-core"

      subnet_id = module.subnets.ids["sub02-${var.country}-${var.environment}-backend"]
      #pip_id    = module.public_ips.ids["pip2-${var.country}-${var.environment}-vm02"]

      size = "Standard_B2s"

      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }

      tags = local.common_tags
    }
  }



  sql = {
    name                = "sql-${var.country}-${var.environment}"
    resource_group_name = "rg-${var.country}-${var.environment}-core"
    location            = var.location

    database_name = "appdb"
    database_sku  = "Basic"

    admin_username_secret_name = "admin-username"
    admin_password_secret_name = "sql-admin-password"

    allowed_ip = "49.207.219.38"

    tags = local.common_tags
  }
}