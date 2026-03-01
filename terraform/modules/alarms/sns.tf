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
