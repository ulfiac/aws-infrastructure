data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid    = "AWSBudgetsSNSPublishingPermissions"
    effect = "Allow"
    resources = [
      "arn:aws:sns:${local.aws_region}:${local.aws_account_id}:${local.sns_topic_name}",
    ]

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
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
      values   = ["arn:aws:budgets::${local.aws_account_id}:*"]
    }
  }
}

data "aws_kms_key" "sns" {
  key_id = "alias/aws/sns"
}

data "aws_region" "current" {}
