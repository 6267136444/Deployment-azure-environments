module "web_server" {
  source = "git::https://github.com/6267136444/terraform-azure-modules.git//modules/linux-vm?ref=main"

  location            = var.location
  resource_group_name = var.resource_group_name
  vm_name             = "webserver"
  vm_size             = "Standard_D2as_v5"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

module "db_server" {
  source = "git::https://github.com/6267136444/terraform-azure-modules.git//modules/linux-vm?ref=main"

  location            = var.location
  resource_group_name = var.resource_group_name
  vm_name             = "dbserver"
  vm_size             = "Standard_D4als_v6"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}
