resource "aws_sns_topic" "notify_upstream" {
  name              = local.sns_topic_name
  kms_master_key_id = aws_kms_key.logs.key_id
}

resource "aws_sns_topic_subscription" "notify_upstream_via_email" {
  topic_arn = aws_sns_topic.notify_upstream.arn
  protocol  = "email"
  endpoint  = local.sns_endpoint_email
}
