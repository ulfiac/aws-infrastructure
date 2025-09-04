resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = 30
  kms_key_id        = aws_kms_key.logging.arn
}

resource "aws_cloudwatch_log_metric_filter" "root_user" {
  name           = local.cloudwatch_log_metric_filter_name_root_user
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ ($.userIdentity.type = \"Root\") && ($.userIdentity.invokedBy NOT EXISTS) && ($.eventType != \"AwsServiceEvent\") }"
  #pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.userName = \"root\" }"

  metric_transformation {
    name          = "RootUserActivityCount"
    namespace     = "CloudTrailMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_user" {
  alarm_description = "This metric monitors for root user activity."
  alarm_name        = local.cloudwatch_metric_alarm_name_root_user

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.root_user.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.root_user.metric_transformation[0].namespace
  period              = 300 # in seconds, 5 minutes
  statistic           = "Sum"
  threshold           = 1

  alarm_actions = [aws_sns_topic.notify_upstream.arn]
  ok_actions    = [aws_sns_topic.notify_upstream.arn]
}

resource "aws_cloudwatch_log_metric_filter" "console_login_without_mfa" {
  name           = local.cloudwatch_log_metric_filter_name_console_login_without_mfa
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ ($.eventName = ConsoleLogin) && ($.additionalEventData.MFAUsed != Yes) }"

  metric_transformation {
    name          = "ConsoleLoginWithoutMFACount"
    namespace     = "CloudTrailMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_login_without_mfa" {
  alarm_description = "This metric monitors for console login attempts without MFA."
  alarm_name        = local.cloudwatch_metric_alarm_name_console_login_without_mfa

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.console_login_without_mfa.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.console_login_without_mfa.metric_transformation[0].namespace
  period              = 300 # in seconds, 5 minutes
  statistic           = "Sum"
  threshold           = 1

  alarm_actions = [aws_sns_topic.notify_upstream.arn]
  ok_actions    = [aws_sns_topic.notify_upstream.arn]
}
