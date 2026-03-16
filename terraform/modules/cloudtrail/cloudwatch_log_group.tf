#trivy:ignore:AVD-AWS-0017 (LOW): Log group is not encrypted.
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = 30
}
