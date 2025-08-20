#trivy:ignore:AVD-AWS-0062 (MEDIUM): Password policy allows a maximum password age of greater than 90 days.
resource "aws_iam_account_password_policy" "password_policy" {
  allow_users_to_change_password = false
  hard_expiry                    = false
  max_password_age               = 180
  minimum_password_length        = 42
  password_reuse_prevention      = 10
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
}
