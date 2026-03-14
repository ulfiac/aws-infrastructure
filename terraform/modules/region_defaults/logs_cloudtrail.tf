#trivy:ignore:AVD-AWS-0015 (HIGH): CloudTrail does not use a customer managed key to encrypt the logs.
#trivy:ignore:AVD-AWS-0014 (MEDIUM): Trail is not enabled across all regions.
#trivy:ignore:AWS-0162 (LOW): Trail does not have CloudWatch logging configured
resource "aws_cloudtrail" "single_region_trail" {
  name = local.cloudtrail_name

  enable_log_file_validation    = true
  enable_logging                = true
  include_global_service_events = false
  is_multi_region_trail         = false

  s3_bucket_name = aws_s3_bucket.logs.bucket
  s3_key_prefix  = "cloudtrail" # must not have trailing slash

  depends_on = [
    aws_s3_bucket_policy.logs,
    aws_s3_bucket_server_side_encryption_configuration.logs,
  ]
}

data "aws_iam_policy_document" "cloudtrail" {

  statement {
    sid       = "AllowCloudTrailAclCheck"
    actions   = ["s3:GetBucketAcl"]
    effect    = "Allow"
    resources = [aws_s3_bucket.logs.arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${local.aws_region}:${local.aws_account_id}:trail/${local.cloudtrail_name}"]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid       = "AllowCloudTrailWrite"
    actions   = ["s3:PutObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.logs.arn}/cloudtrail/AWSLogs/${local.aws_account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${local.aws_region}:${local.aws_account_id}:trail/${local.cloudtrail_name}"]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}
