output "user_passwords" {
  description = "The generated passwords for each user"
  value       = { for user in var.users : user => random_password.users[user].result }
  sensitive   = true # Mark as sensitive to hide from the default Terraform output
}

