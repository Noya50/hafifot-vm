variable "vm_name" {
  description = "(Required) The name of the vm resource"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the vm will be created."
  type        = string
}

variable "location" {
  description = "(Required) The location of the vm."
  type        = string
}

variable "subnet_id" {
  description = "(Required) The id of the existing subnet in which the machine will be created"
  type        = string
}

variable "admin_username" {
  description = "(Required) The username that will be used for authentication when connecting to the machine."
  type        = string
}

variable "admin_password" {
  description = "(Required) The password that will be used for authentication when connecting to the machine."
  type        = string
}

variable "names_prefix" {
  description = "(Optional) A prefix that will open the default names of part of the resources. Better end with a hyphen"
  default     = ""
  type        = string
}

variable "nic_name" {
  description = "(Optional) The name of the network interface card of the vm"
  default     = "nic-tf"
  type        = string
}

variable "nic_ip_name" {
  description = "(Optional) The name of the ip of the vm"
  default     = "ip-tf"
  type        = string
}

variable "nic_private_ip_allocation" {
  description = "(Optional) The allocation method of private ip address for the vm"
  default     = "Dynamic"
  type        = string
}

variable "size" {
  description = "(Optional) The SKU which should be used for this Virtual Machine"
  default     = "Standard_D2s_v3"
  type        = string
}

variable "os_disks" {
  description = "value"
  type = list(object({
    caching = string
    storage_account_type = string
  }))
  default = [ {
    caching = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }, ]
}

variable "os" {
  description = "(Optional) The operating system of the machine."
  type        = string
  default     = "linux"
  validation {
    condition     = can(regex("^(linux|windows)$", var.os))
    error_message = "Invalid operating system. os must be 'linux' or 'windows'. Default 'linux'."
  }
}

variable "source_linux_image" {
  description = "(Optional) The source image of linux vm."
  type        = string
  default     = "ubuntu"
  validation {
    condition     = can(regex("^(ubuntu|CentOS)$", var.source_linux_image))
    error_message = "Invalid operating system. os must be 'ubuntu' or 'CentOS'. Default 'Ubuntu'."
  }
}

variable "source_windows_image" {
  description = "(Optional) The source image of windows vm."
  type        = string
  default     = "windows10"
  validation {
    condition     = can(regex("^(windows10|windowsServer)$", var.source_linux_image))
    error_message = "Invalid operating system. os must be 'windows10' or 'windowsServer'. Default 'windows10'."
  }
}

locals {
  source_image_publisher = {
    "CentOS"        = "OpenLogic"
    "ubuntu"        = "Canonical"
    "windows10"     = "MicrosoftWindowsDesktop"
    "windowsServer" = "MicrosoftWindowsServer"
  }
  source_image_offer = {
    "CentOS"        = "CentOS"
    "ubuntu"        = "0001-com-ubuntu-server-jammy"
    "windows10"     = "Windows-10"
    "windowsServer" = "WindowsServer"
  }
  source_image_sku = {
    "CentOS"        = "7_9"
    "ubuntu"        = "22_04-lts"
    "windows10"     = "2016-Datacenter"
    "windowsServer" = "Windo21h2-prowsServer"
  }
  source_image_version = "latest"
}

variable "source_image_sku" {
  description = "(Optional) The sku of the desired source image."
  default     = null
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the vm resource."
  type        = map(string)
  default     = {}
}

variable "identity" {
  description = "(Optional) Add identity to the vm. default to 'SystemAssigned' type only, 'UserAssigned' or 'SystemAssigned, UserAssigned' requires to add 'identity_ids'."
  type = object({
    identity_ids = set(string)
    type         = string
  })
  default = {
    identity_ids = []
    type         = "SystemAssigned"
  }
}

variable "log_analytics_workspace_id" {
  description = "(Required) ID of the log analytics workspace to which the diagnostic setting will send the logs of this resource."
  type        = string
  default     = null
}
