locals {
  aws_account_id      = data.aws_caller_identity.current.account_id
  aws_region          = data.aws_region.current.region
  aws_regions_enabled = data.aws_regions.enabled.names

  cloudtrail_athena_table_name = "cloudtrail_multi_region_new" # should be lowercase letters, numbers, or underscore
  cloudtrail_name              = "new-multi-region-trail-${local.aws_account_id}-${local.aws_region}"
  cloudtrail_s3_key_prefix     = "cloudtrail"

  cloudwatch_log_group_name = "/aws/cloudtrail/${local.cloudtrail_name}"

  iam_policy_name_cloudtrail_to_cloudwatch = "new-cloudtrail-to-cloudwatch"
  iam_role_name_cloudtrail_to_cloudwatch   = "new-cloudtrail-to-cloudwatch"
}
