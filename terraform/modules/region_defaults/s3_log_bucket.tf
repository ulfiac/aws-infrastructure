#trivy:ignore:AVD-AWS-0089 (LOW): Bucket has logging disabled
resource "aws_s3_bucket" "logs" {
  bucket = local.s3_log_bucket_name
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expire_noncurrent_versions"
    status = "Enabled"
    filter {}
    noncurrent_version_expiration {
      noncurrent_days = 10
    }
  }

  rule {
    id     = "expire_current_versions"
    status = "Enabled"
    filter {}
    expiration {
      days = 10
    }
  }

  rule {
    id     = "abort_incomplete_multipart_uploads"
    status = "Enabled"
    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }
  }
}

#trivy:ignore:AVD-AWS-0132 (HIGH): Bucket does not encrypt data with a customer managed key.
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

data "aws_iam_policy_document" "logs" {
  source_policy_documents   = []
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
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "DenyAbsentEncryptionHeader"
    actions   = ["s3:PutObject"]
    effect    = "Deny"
    resources = ["${aws_s3_bucket.logs.arn}/*"]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }

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

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.logs.json
}
