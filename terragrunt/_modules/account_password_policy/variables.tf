variable "allow_users_to_change_password" {
  description = "Whether to allow IAM users to change their own password."
  type        = bool
  default     = true
}

variable "hard_expiry" {
  description = "Whether to prevent IAM users from setting a new password after their password has expired."
  type        = bool
  default     = false
}

variable "max_password_age" {
  description = "The maximum password age (in days) that an IAM user password is valid."
  type        = number
  default     = 180
}

variable "minimum_password_length" {
  description = "The minimum length to require for IAM user passwords."
  type        = number
  default     = 42
}
