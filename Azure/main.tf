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
