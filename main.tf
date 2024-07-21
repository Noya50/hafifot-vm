resource "azurerm_network_interface" "this" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.nic_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.nic_private_ip_allocation
  }

  lifecycle {
    ignore_changes = [tags, ]
  }
}

module "diagnostic_setting" {
  source = "https://github.com/Noya50/hafifot-diagnosticSetting.git"

  name                       = "${azurerm_network_interface.this.name}-diagnostic-setting"
  target_resource_id         = azurerm_network_interface.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  diagnostic_setting_categories = var.nic_diagnostic_setting_categories
}

resource "azurerm_linux_virtual_machine" "this" {
  for_each =  var.os == "linux" ? tomap({0 = true}) : tomap({})
  
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  identity {
    identity_ids = var.identity.identity_ids
    type         = var.identity.type
  }

  dynamic "os_disk" {
    for_each = var.os_disks != null ? var.os_disks : []
    content {
      caching              = os_disk.value.caching
      storage_account_type = os_disk.value.storage_account_type
    }
  }

  dynamic "source_image_reference" {
    for_each = var.source_linux_image == "ubuntu" ? [1] : []
    content {
      publisher = local.source_image_publisher.ubuntu
      offer     = local.source_image_offer.ubuntu
      sku       = var.source_image_sku != null ? var.source_image_sku : local.source_image_sku.ubuntu
      version   = local.source_image_version
    }
  }

  dynamic "source_image_reference" {
    for_each = var.source_linux_image == "CentOS" ? [1] : []
    content {
      publisher = local.source_image_publisher.CentOS
      offer     = local.source_image_offer.CentOS
      sku       = var.source_image_sku != null ? var.source_image_sku : local.source_image_sku.CentOS
      version   = local.source_image_version
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_windows_virtual_machine" "this" {
  for_each = var.os == "windows" ? toset(["true"]) : toset([])

  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  dynamic "os_disk" {
    for_each = var.os_disks != null ? [var.os_disks] : []
    content {
      caching              = os_disk.value.caching
      storage_account_type = os_disk.value.storage_account_type
    }
  }

  dynamic "source_image_reference" {
    for_each = var.source_linux_image == "windows10" ? [1] : []
    content {
      publisher = local.source_image_publisher.windows10
      offer     = local.source_image_offer.windows10
      sku       = var.source_image_sku != null ? var.source_image_sku : local.source_image_sku.windows10
      version   = local.source_image_version
    }
  }

  dynamic "source_image_reference" {
    for_each = var.source_linux_image == "windowsServer" ? [1] : []
    content {
      publisher = local.source_image_publisher.windowsServer
      offer     = local.source_image_offer.windowsServer
      sku       = var.source_image_sku != null ? var.source_image_sku : local.source_image_sku.windowsServer
      version   = local.source_image_version
    }
  }
}
