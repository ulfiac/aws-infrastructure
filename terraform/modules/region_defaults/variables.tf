variable "log_bucket_name" {
  description = "Name of the S3 bucket to store logs"
  type        = string
}

variable "log_bucket_arn" {
  description = "ARN of the S3 bucket to store logs"
  type        = string
}

variable "verbose_output" {
  description = "Enable verbose output for debugging purposes"
  type        = bool
  default     = false
}
