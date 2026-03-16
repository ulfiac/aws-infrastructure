variable "athena_database_name" {
  description = "The name of the Athena database where the table for CloudTrail logs will be created."
  type        = string
}

variable "aws_account_email" {
  description = "The email address for SNS alarm notifications."
  type        = string
  sensitive   = true
}

variable "log_bucket_name" {
  description = "The name of the S3 bucket to store CloudTrail logs."
  type        = string
}

