# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/US_SetupSNS.html
data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid    = "CloudWatchAlarmsSNSPublishingPermissions"
    effect = "Allow"
    resources = [
      "arn:aws:sns:${local.aws_region}:${local.aws_account_id}:${local.sns_topic_name}",
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }

    actions = [
      "SNS:Publish",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.aws_account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_cloudwatch_log_group.cloudtrail.arn]
    }
  }
}

#trivy:ignore:AVD-AWS-0095 (HIGH): Topic does not have encryption enabled.
resource "aws_sns_topic" "alarms" {
  name   = local.sns_topic_name
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "alarms" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.aws_account_email
}

