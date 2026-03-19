locals {
  aws_account_id      = data.aws_caller_identity.current.account_id
  aws_organization_id = var.enable_cloudtrail_logs ? data.aws_organizations_organization.current.id : null
  aws_region          = data.aws_region.current.region

  s3_log_bucket_name = "logs-${local.aws_account_id}-${local.aws_region}"
}
