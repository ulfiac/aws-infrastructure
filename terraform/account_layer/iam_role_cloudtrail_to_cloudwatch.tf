# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/send-cloudtrail-events-to-cloudwatch-logs.html
# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudwatch-log-group-log-stream-naming-for-cloudtrail.html
# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-required-policy-for-cloudwatch-logs.html

data "aws_iam_policy_document" "cloudtrail_to_cloudwatch_assume_role_policy" {
  statement {
    sid     = "AllowCloudTrailToAssumeRoleToCloudWatch"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "cloudtrail_to_cloudwatch_role" {
  name               = local.iam_role_name_cloudtrail_to_cloudwatch
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_to_cloudwatch_assume_role_policy.json
}

data "aws_iam_policy_document" "cloudtrail_to_cloudwatch_policy" {
  statement {
    sid    = "AWSCloudTrailCreateLogStream"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
    ]
    resources = ["${aws_cloudwatch_log_group.cloudtrail.arn}:log-stream:${local.account_id}_CloudTrail_${local.region}*"]
  }

  statement {
    sid    = "AWSCloudTrailPutLogEvents"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
    ]
    resources = ["${aws_cloudwatch_log_group.cloudtrail.arn}:log-stream:${local.account_id}_CloudTrail_${local.region}*"]
  }
}

resource "aws_iam_role_policy" "cloudtrail_to_cloudwatch_policy" {
  name   = local.iam_policy_name_cloudtrail_to_cloudwatch
  policy = data.aws_iam_policy_document.cloudtrail_to_cloudwatch_policy.json
  role   = aws_iam_role.cloudtrail_to_cloudwatch_role.name
}
