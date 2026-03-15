variable "athena_database_name" {
  description = "The name of the Athena database where the table for CloudTrail logs will be created."
  type        = string
}

variable "log_bucket_name" {
  description = "The name of the S3 bucket to store CloudTrail logs."
  type        = string
}
