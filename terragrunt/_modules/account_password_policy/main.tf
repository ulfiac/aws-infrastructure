#trivy:ignore:AVD-AWS-0062 (MEDIUM): Password policy allows a maximum password age of greater than 90 days.
resource "aws_iam_account_password_policy" "password_policy" {
  allow_users_to_change_password = var.allow_users_to_change_password
  hard_expiry                    = var.hard_expiry
  max_password_age               = var.max_password_age
  minimum_password_length        = var.minimum_password_length
  password_reuse_prevention      = 10
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
}
