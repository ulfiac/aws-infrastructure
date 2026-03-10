locals {
  availability_zones = [for subnet in data.aws_subnet.default : subnet.availability_zone]

  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.region

  athena_database_name  = "logs_${replace(local.aws_region, "-", "_")}" # must be lowercase letters, numbers, or underscore
  athena_workgroup_name = "logs_${local.aws_region}"
  s3_log_bucket_name    = "log-bucket-${local.aws_account_id}-${local.aws_region}"
}
