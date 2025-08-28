#trivy:ignore:AVD-AWS-0089 (LOW): Bucket has logging disabled
resource "aws_s3_bucket" "logging" {
  bucket = local.s3_bucket_name_logging
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "logging" {
  bucket = aws_s3_bucket.logging.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    id     = "expire_old_versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.logging.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

data "aws_iam_policy_document" "logging" {
  statement {
    sid     = "EnforceTLS"
    actions = ["s3:*"]
    effect  = "Deny"
    resources = [
      aws_s3_bucket.logging.arn,
      "${aws_s3_bucket.logging.arn}/*",
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
    resources = ["${aws_s3_bucket.logging.arn}/*"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingKMSEncryption.html
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingKMSEncryption.html#require-sse-kms
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html#example-bucket-policies-encryption
  statement {
    sid       = "DenyAbsentOrIncorrectEncryptionHeader"
    actions   = ["s3:PutObject"]
    effect    = "Deny"
    resources = ["${aws_s3_bucket.logging.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    # deny if kms cmk arn is absent or incorrect
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [aws_kms_key.logging.arn]
    }
  }

  statement {
    sid     = "AllowRootAccess"
    actions = ["s3:*"]
    effect  = "Allow"
    resources = [
      aws_s3_bucket.logging.arn,
      "${aws_s3_bucket.logging.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  statement {
    sid       = "AllowCloudTrailAclCheck"
    actions   = ["s3:GetBucketAcl"]
    effect    = "Allow"
    resources = [aws_s3_bucket.logging.arn]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid       = "AllowCloudTrailWrite"
    actions   = ["s3:PutObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.logging.arn}/${local.cloudtrail_s3_key_prefix}/AWSLogs/${local.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "logging" {
  bucket = aws_s3_bucket.logging.id
  policy = data.aws_iam_policy_document.logging.json
}
