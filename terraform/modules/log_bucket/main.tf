locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.region

  s3_log_bucket_name = "log-bucket-${local.aws_account_id}-${local.aws_region}"
}
