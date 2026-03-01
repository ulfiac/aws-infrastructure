variable "log_group_name_for_cloudtrail" {
  description = "The name of the CloudWatch log group for CloudTrail."
  type        = string
}

variable "aws_account_email" {
  description = "The email address for SNS alarm notifications."
  type        = string
  sensitive   = true
}
