variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "unique_name" {
  description = "String the can be added to names that must be unique (eg s3 buckets, etc)."
  type        = string
}
