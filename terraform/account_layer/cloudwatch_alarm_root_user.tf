resource "aws_cloudwatch_log_metric_filter" "root_user" {
  name           = local.cloudwatch_log_metric_filter_name_root_user
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ ($.userIdentity.type = \"Root\") && ($.userIdentity.invokedBy NOT EXISTS) && ($.eventType != \"AwsServiceEvent\") }"

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
