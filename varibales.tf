variable "users" {
  type        = list(any)
  description = "name of the user"
}

variable "subscription_id" {
  description = "The Azure subscription ID to use"
  type        = string
}

variable "group_name" {
  description = "User group name"
  type        = string
  default     = null
}


variable "role_name" {
  description = "Name of the Azure role to assign to users. Leave null if no role is needed."
  type        = string
  default     = null  # Set the role here if needed, like "Contributor"
}