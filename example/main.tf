provider "azuread" {
  use_msi          = false  
  tenant_id        = data.azurerm_client_config.current.tenant_id
  
}

provider "azurerm" {
  features {}
}

module "azure_ad_users" {
  source = "../rbac-1" 
  users           = ["test", "first"]
subscription_id = "cd857ad4-3d95-4df9-957d-a2e12a9d68b4"
group_name      = null
role_name  = "Contributor"
}

output "generated_passwords" {
  value = module.azure_ad_users.user_passwords
  sensitive = true
}
