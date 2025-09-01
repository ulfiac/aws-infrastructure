locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.region

  athena_database_name         = "logs" # must be lowercase letters, numbers, or underscore
  athena_table_name_cloudtrail = "cloudtrail_logs"
  athena_workgroup_name        = "logs"

  cloudtrail_name = "multi-region-trail"

  cloudwatch_log_group_name                   = "/aws/cloudtrail/${local.cloudtrail_name}"
  cloudwatch_log_metric_filter_name_root_user = "root-user-activity"
  cloudwatch_metric_alarm_name_root_user      = "root-user-activity"

  iam_group_name                           = "default-group"
  iam_policy_name_cloudtrail_to_cloudwatch = "cloudtrail-to-cloudwatch"
  iam_policy_name_mfa                      = "enforce-mfa"
  iam_policy_name_roleswitch               = "role-switch"
  iam_role_name_admin                      = "role-switch-admin"
  iam_role_name_cloudtrail_to_cloudwatch   = "cloudtrail-to-cloudwatch"
  iam_role_name_poweruser                  = "role-switch-power-user"
  iam_user_name                            = "actual"

  kms_key_alias = "alias/cmk/logging"

  s3_bucket_name_logging   = "logging-${var.unique_name}"
  s3_key_prefix_athena     = "athena"
  s3_key_prefix_cloudtrail = "cloudtrail"

  sns_topic_name = "notify-upstream"
}
