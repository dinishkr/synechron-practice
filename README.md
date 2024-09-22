# Azure AD User and Role Management with Terraform

This Terraform configuration provisions Azure AD users, assigns them to a specific Azure AD group, and assigns them roles within an Azure subscription. It also generates random passwords for the users and ensures they are required to change their passwords upon initial login.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- Azure subscription with appropriate permissions
- Azure Active Directory (AD) tenant
- Service Principal credentials with permissions to manage users, groups, and role assignments in Azure AD

## Features

This Terraform configuration includes the following resources:

- **Azure AD Users**: Creates a list of users with random passwords.
- **Azure AD Group Membership**: Adds the newly created users to an existing Azure AD group.
- **Azure Role Assignment**: Assigns roles to the users at the subscription level.
  
## Components

### Provider

- **Azure Active Directory Provider (`azuread`)**: Used to manage users and groups in Azure AD.
- **Azure Resource Manager Provider (`azurerm`)**: Used to manage Azure resources, including role assignments.

### Data Sources

- `azuread_domains`: Retrieves the default Azure AD domain.
- `azuread_group`: Retrieves the target group by name from Azure AD.
- `azurerm_role_definition`: Retrieves the role definition by name from the Azure subscription.

### Resources

- `azuread_user`: Creates a user for each entry in the provided list of usernames.
- `random_password`: Generates random passwords for the users.
- `azuread_group_member`: Adds the created users to the specified Azure AD group.
- `azurerm_role_assignment`: Assigns the specified role to the created users at the subscription level.

## Usage

1. Clone this repository or copy the provided Terraform code.
2. Initialize Terraform:

    ```bash
    terraform init
    ```

3. Create a `terraform.tfvars` file or set the following variables:

    ```hcl
    subscription_id = "<your_subscription_id>"
    group_name      = "<target_group_name>"
    role_name       = "<target_role_name>"
    users           = ["user1", "user2", "user3"]
    ```

   - **`subscription_id`**: Your Azure subscription ID where the role will be assigned.
   - **`group_name`**: The name of the Azure AD group to which the users will be added.
   - **`role_name`**: The role to assign the users (e.g., `Contributor`, `Reader`, etc.).
   - **`users`**: A list of usernames (without domain) for which users will be created.

4. Apply the Terraform configuration:

    ```bash
    terraform apply
    ```

5. Confirm the changes and review the output.

## Variables

| Name              | Description                                                 | Type   | Default   | Required |
|-------------------|-------------------------------------------------------------|--------|-----------|----------|
| `subscription_id`  | The Azure subscription ID                                   | string |           | Yes      |
| `group_name`       | The display name of the Azure AD group                      | string | null      | Yes      |
| `role_name`        | The role name to assign to the users (e.g., Contributor)     | string | null      | Yes      |
| `users`            | A list of usernames (without domain) for user creation      | list   |           | Yes      |

## Outputs

- **User Principal Names**: The user principal names (UPNs) of the created users.
- **Group Memberships**: The membership status of the users in the target group.
- **Role Assignments**: The roles assigned to the created users within the subscription.

## Notes

- Ensure that you have the necessary permissions in both Azure AD and the Azure subscription to create users, manage group memberships, and assign roles.
- The passwords for the created users will be randomly generated and can be viewed in the Terraform output. The users will be forced to change their password on first login.

## Clean Up

To remove all resources created by this configuration, run:

```bash
terraform destroy
