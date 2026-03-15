data "aws_iam_policy_document" "logs" {
  source_policy_documents = concat(
    var.enable_vpc_flow_logs ? [data.aws_iam_policy_document.vpc_flow_logs.json] : [],
    var.enable_cloudtrail_logs ? [data.aws_iam_policy_document.cloudtrail_logs.json] : [],
  )
  override_policy_documents = []

  statement {
    sid     = "EnforceTLS"
    actions = ["s3:*"]
    effect  = "Deny"
    resources = [
      aws_s3_bucket.logs.arn,
      "${aws_s3_bucket.logs.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    actions   = ["s3:PutObject"]
    effect    = "Deny"
    resources = ["${aws_s3_bucket.logs.arn}/*"]

    condition {
      test     = "StringNotEqualsIfExists"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "DenyObjectDeletion"
    actions   = ["s3:DeleteObject", "s3:DeleteObjectVersion"]
    effect    = "Deny"
    resources = ["${aws_s3_bucket.logs.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid     = "AllowRootAccess"
    actions = ["s3:*"]
    effect  = "Allow"
    resources = [
      aws_s3_bucket.logs.arn,
      "${aws_s3_bucket.logs.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.aws_account_id}:root"]
    }
  }
}
