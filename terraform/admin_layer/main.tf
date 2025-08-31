locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.region

  cloudtrail_name          = "multi-region-trail"
  cloudtrail_s3_key_prefix = "cloudtrail"

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

  s3_bucket_name_logging = "logging-${var.unique_name}"

  sns_topic_name = "notify-upstream"
}
