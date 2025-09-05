resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = 30
  kms_key_id        = aws_kms_key.logs.arn
}
