# Terraform - Personal Learning Notes

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
- Limited to Azure - **unlike Terraform*
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
- Blocks
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
