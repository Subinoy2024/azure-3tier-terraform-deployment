data "azurerm_subnet" "this" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}
resource "azurerm_bastion_host" "this" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = data.azurerm_subnet.this.id
    public_ip_address_id = var.public_ip_id
  }

  tags = var.tags
}
