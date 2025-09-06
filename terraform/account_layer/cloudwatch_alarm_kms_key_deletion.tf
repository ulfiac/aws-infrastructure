resource "aws_cloudwatch_log_metric_filter" "kms_key_deletion" {
  name           = local.cloudwatch_log_metric_filter_name_kms_key_deletion
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ ($.eventName = \"DeleteKey\") && ($.eventSource = \"kms.amazonaws.com\") }"

  metric_transformation {
    name          = "KmsKeyDeletionCount"
    namespace     = "CloudTrailMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "kms_key_deletion" {
  alarm_description = "This metric monitors for kms key deletions."
  alarm_name        = local.cloudwatch_metric_alarm_name_kms_key_deletion

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.kms_key_deletion.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.kms_key_deletion.metric_transformation[0].namespace
  period              = 300 # in seconds, 5 minutes
  statistic           = "Sum"
  threshold           = 1

  alarm_actions = [aws_sns_topic.notify_upstream.arn]
  ok_actions    = [aws_sns_topic.notify_upstream.arn]
}
