locals {
  aws_account_id      = data.aws_caller_identity.current.account_id
  aws_region          = data.aws_region.current.region
  aws_regions_enabled = data.aws_regions.enabled.names

  cloudtrail_athena_table_name = "cloudtrail_multi_region_new" # should be lowercase letters, numbers, or underscore
  cloudtrail_name              = "new-multi-region-trail-${local.aws_account_id}-${local.aws_region}"
  cloudtrail_s3_key_prefix     = "cloudtrail"

  cloudwatch_log_group_name                                   = "/aws/cloudtrail/${local.cloudtrail_name}"
  cloudwatch_log_metric_filter_name_console_login_without_mfa = "console-login-without-mfa-new"
  cloudwatch_log_metric_filter_name_root_user                 = "root-user-activity-new"
  cloudwatch_metric_alarm_name_console_login_without_mfa      = "console-login-without-mfa-new"
  cloudwatch_metric_alarm_name_root_user                      = "root-user-activity-new"

  iam_policy_name_cloudtrail_to_cloudwatch = "new-cloudtrail-to-cloudwatch"
  iam_role_name_cloudtrail_to_cloudwatch   = "new-cloudtrail-to-cloudwatch"

  sns_topic_name = "cloudwatch-alarms-new"

}
