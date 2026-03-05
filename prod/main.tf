resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "CCRH-Vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "web_subnet" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "web_pip" {
  name                = "webserver-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "web_nic" {
  name                = "web-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_pip.id
  }
}

resource "azurerm_network_interface" "db_nic" {
  name                = "db-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.db_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

module "web_server" {
  source = "git::https://github.com/6267136444/terraform-azure-modules.git//modules/linux-vm"

  vm_name             = "server-web"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size             = "Standard_D2as_v5"

  admin_username = var.admin_username
  admin_password = var.admin_password

  nic_id = azurerm_network_interface.web_nic.id
}

module "db_server" {
  source = "git::https://github.com/6267136444/terraform-azure-modules.git//modules/linux-vm"

  vm_name             = "server-db"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size             = "Standard_D2as_v5"

  admin_username = var.admin_username
  admin_password = var.admin_password

  nic_id = azurerm_network_interface.db_nic.id
}
