
# Configure the Azure Active Directory Provider
provider "azuread" {}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Retrieve domain information
data "azuread_domains" "default" {
  only_initial = true
}

data "azuread_group" "target_group" {
  display_name = var.group_name
  count        = var.group_name != null ? 1 : 0
}

data "azurerm_role_definition" "role" {
  name  = var.role_name
  count = var.role_name != null ? 1 : 0  
}

locals {
  domain_name = data.azuread_domains.default.domains.0.domain_name
  
}



# Create users
resource "azuread_user" "users" {
  for_each = toset(var.users)
  user_principal_name = format(
    "%s@%s",
    lower(each.value),
    local.domain_name
  )

  password              = random_password.users[each.key].result
  force_password_change = true
  display_name          = each.value
}

# Generate random passwords for each user
resource "random_password" "users" {
  for_each = toset(var.users)

  length  = 16
  special = true
}

resource "azuread_group_member" "group_membership" {
  for_each         = var.group_name != null ? azuread_user.users : {}
  group_object_id  = data.azuread_group.target_group[0].id
  member_object_id = each.value.id
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each = var.role_name != null ? azuread_user.users : {}
  principal_id   = each.value.id  
  role_definition_id = data.azurerm_role_definition.role[0].id
  scope          = "/subscriptions/${var.subscription_id}"
}

