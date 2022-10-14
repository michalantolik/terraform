# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "main" {
    name = "learn-tf-rg-westeurope"
    location = "westeurope"
}

# Create VNet
resource "azurerm_virtual_network" "main" {
    name = "learn-tf-vnet-westus"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    address_space = [ "10.0.0.0/16" ]
}

# Create subnet
resource "azurerm_subnet" "main" {
  name = "learn-tf-subnet-westeurope"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name = azurerm_resource_group.main.name
  address_prefixes = [ "10.0.0.0/24" ]
}

# Create internal network interface card (internal NIC)
resource "azurerm_network_interface" "internal" {
  name = "learn-tf-nic-int-westeurope"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create Windows virtual machine  (Windows VM)
# https://learn.hashicorp.com/tutorials/terraform/sensitive-variables
variable "main_windows_vm_username" {
  description = "\"main\" Windows VM username"
  type = string
  sensitive = true
}

variable "main_windows_vm_password" {
  description = "\"main\" Windows VM password"
  type = string
  sensitive = true
}

resource "azurerm_windows_virtual_machine" "main" {
  name = "learn-tf-vm-weu"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  size = "Standard_B1s"
  admin_username = var.main_windows_vm_username
  admin_password = var.main_windows_vm_password

  network_interface_ids = [
    azurerm_network_interface.internal.id
  ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-DataCenter"
    version = "latest"
  }
}
