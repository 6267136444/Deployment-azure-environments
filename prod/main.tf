module "linux_vm" {
  source = "git::https://github.com/6267136444/terraform-azure-modules.git//modules/linux-vm?ref=main"

  location            = var.location
  resource_group_name = var.resource_group_name
  vm_name             = var.vm_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}
