# Terraform - Personal Learning Notes

## Terraform - Resources
- https://www.linkedin.com/learning/introduction-to-terraform-on-azure/

## Terraform is an infrastructure automation tool from HashiCorp
- Implements Infrastructure as Code (IaC) concept
- Uses HashiCorp Configuration Language (HCL) - *declarative configuration files*
- Push based deployment - *configuration is pushed to the target environment*
- Idempotent - *applying the same operation multiple times will not change the result*
- Open source, cloud vendor agnostic, cross-platform
- Single binary compiled from Go
- State file must be maintained
- May take time to support new Azure features

## BICEP is an infrastructure automation tool from Microsoft
- Uses declarative, human-readable syntax - *like Terraform*
- Limited to Azure - *unlike Terraform*
- State file automatically managed - *unlike Terraform*
- Immediate support for new Azure features - *unlike Terraform*

## Infrastructure as Code:
- Provisioning infrastructure through software ...
- ... to achieve consistent and predictable deployments

## Infrastructure as Code - features:
- Defined in code ...
- Stored in source control
- Declarative or imperative

## Infrastructure as Code - benefits:
- Automated deployment - *fast and reliable - eliminates human mistakes*
- Repeatable process for creating consistent environments
- Reusable components - *DRY - Don't Repeat Yourself*
- Documented architecture
- Version controlled

## Infrastructure as Code - Azure tools:
- ARM templates
- BICEP
- Terraform

## Terraform - Declarative configuration files
- Resource Blocks - *describe one or more infrastracture objects*
- Arguments
- Exceptions

## Terraform - Example setup
- Windows PC + PowerShell + Azure account + Azure CLI + Terraform + VS Code

## Terraform - How to install
- Install Chocolatey --> `choco install terraform` --> `terraform -help`

## Terraform - How to start
- Create folder --> Create `main.tf` file
- Open VS Code --> Connect to Azure account (`az login`)

## Terraform - Basic commands
- `terraform -help` - show help
- `terraform init` - create working directory
- `terraform validate` - check whether configuration is valid
- `terraform plan` - show changes required by the current configuration
- `terraform apply` - execute actions from plan to create/update/destroy infrastructure
- `terraform destroy` - destroys infrastructure

## Terraform - More commands
- `terraform workspace show` - show current workspace
- `terraform workspace list` - list workspaces
- `terraform workspace new dev` - create `dev` workspace
- `terraform workspace select dev` - select `dev` workspace

## Terraform - Workspaces
#### Terraform Cloud workspaces
- Create **separate working directories**
#### Terraform CLI workspaces
- Store separate instances of state data **within the same working directory**

## Terraform - State file
- JSON state file ...
- ... maps real world resources to your configuration
- ... keeps track of metadata
- ... improves performance for large infrastructures
- HINT: Avoid editing state file manually!

## Terraform - State file - Where to store
- By default in a local file called `terraform.tfstate`
- Can be stored remotely
  - Azure storage account
  - Terraform cloud
  - Preferred solution
  
## Terraform - State file - Refresh
- Refresh to update the state with the real infrastructure,

## Terraform - Resource block
```tf
resource "azurerm_resource" "example" {
  name = "learn-tf-example"
  location = "eastus"
}
```

## Terraform - Providers
- Providers to interact with various cloud providers (Azure, GCP, AWS) ...

## Terraform - Providers - How to use
- Declare provider
  - Go to https://registry.terraform.io/
  - Select cloud provider -> Documentation
  - Copy "Example usage" from website to configuration file --> `main.tf`
- Install provider
  - `terraform init` - *will install provider and add it to state file*
 - Authenticate to cloud provider using selected method
  - Azure CLI
    - ... recommended when running Terraform locally
  - Service Principal + Client Certificate/Client Secret/Open ID Connect
    - ... recommended when running Terraform in a CI server
  
```tf
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.26.0"
    }
  }
}

provider "azurerm" {
    features {}
}
```

## Terraform - Azure authentication using CLI
See "Authorization" section in documentation https://registry.terraform.io/
  
```tf
az login
az account list
az account set --subscription="SUBSCRIPTION_ID"
```
  
## Terraform - Create resource group
- Declare resource block
- Preview changes - `terraform plan`
- Apply changes - `terraform apply`
- Check that resource group has been created - `az group list`

```tf
# Create resource group
resource "azurerm_resource_group" "main" {
    name = "learn-tf-rg-westeurope"
    location = "westeurope"
}
```

## Terraform - Create virtual network
- Declare resource block
- Preview changes - `terraform plan`
- Apply changes - `terraform apply`
- Check that virtual network has been created - `az network vnet list`

```tf
# Create VNet
resource "azurerm_virtual_network" "main" {
    name = "learn-tf-vnet-westus"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    address_space = [ "10.0.0.0/16" ]
}
```

## Terraform - Create subnet
- Declare resource block
- Preview changes - `terraform plan`
- Apply changes - `terraform apply`
- Check that subnet has been created - `az network vnet list` - *also lists subnets*

```tf
# Create subnet
resource "azurerm_subnet" "main" {
  name = "learn-tf-subnet-westeurope"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name = azurerm_resource_group.main.name
  address_prefixes = [ "10.0.0.0/24" ]
}
```

## Terraform - Create Windows virtual machine (Windows VM)
- Declare resource block
- Preview changes - `terraform plan`
- Apply changes - `terraform apply`
- Check that virtual machine has been created - `az vm list`

```tf
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
```


