#trivy:ignore:AVD-AWS-0015 (HIGH): CloudTrail does not use a customer managed key to encrypt the logs.
resource "aws_cloudtrail" "multi_region_trail" {
  name = local.cloudtrail_name

  enable_log_file_validation    = true
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = false

  s3_bucket_name = var.log_bucket_name
  s3_key_prefix  = local.cloudtrail_s3_key_prefix

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_to_cloudwatch_role.arn

  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }

  depends_on = [
    aws_iam_role_policy.cloudtrail_to_cloudwatch_policy,
    aws_cloudwatch_log_group.cloudtrail,
  ]
}
