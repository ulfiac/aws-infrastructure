data "aws_iam_policy_document" "cmk" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
      type        = "AWS"
    }
  }

  statement {
    sid    = "AllowKeyToBeUsed"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]
    principals {
      identifiers = [
        aws_iam_user.regular_user.arn,
        aws_iam_role.admin.arn,
        aws_iam_role.power_user.arn,
      ]
      type = "AWS"
    }
  }

  statement {
    sid    = "Allow CloudWatch Logs to use the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    resources = ["*"]
    principals {
      identifiers = [
        "logs.us-east-1.amazonaws.com",
        "logs.us-east-2.amazonaws.com",
      ]
      type = "Service"
    }
    # condition {
    #   test     = "ArnEquals"
    #   variable = "kms:EncryptionContext:aws:logs:arn"
    #   values   = ["arn:aws:logs:${var.aws_region}:${local.account_id}:log-group:${local.cloudwatch_log_group_name}"]
    # }
  }

  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-kms-key-policy-for-cloudtrail.html
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/default-kms-key-policy.html
  statement {
    sid    = "Allow CloudTrail to encrypt logs"
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:SourceArn"
    #   values   = ["arn:aws:cloudtrail:region:account-id:trail/trail-name"]
    # }
    # condition {
    #   test     = "StringLike"
    #   variable = "kms:EncryptionContext:aws:cloudtrail:arn"
    #   values   = ["arn:aws:cloudtrail:*:account-id:trail/*"]
    # }
  }

  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingKMSEncryption.html
  statement {
    sid    = "Allow S3 to use the key for encryption"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]
    principals {
      identifiers = ["s3.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    sid    = "Allow CloudTrail-to-CloudWatch role to use the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    resources = ["*"]
    principals {
      identifiers = [aws_iam_role.cloudtrail_to_cloudwatch_role.arn]
      type        = "AWS"
    }
  }

  statement {
    sid    = "Allow SNS to use the key"
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt",
    ]
    resources = ["*"]
    principals {
      identifiers = ["sns.amazonaws.com"]
      type        = "Service"
    }
  }

  # is a statement for user administration needed (role-switch-admin role)?

}

resource "aws_kms_key" "logging" {
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  multi_region            = true
  policy                  = data.aws_iam_policy_document.cmk.json
  rotation_period_in_days = 365
}

resource "aws_kms_alias" "logging" {
  name          = "alias/cmk/logging"
  target_key_id = aws_kms_key.logging.key_id
}
