resource "aws_ebs_encryption_by_default" "default" {
  enabled = true
}

resource "aws_ebs_default_kms_key" "default" {
  key_arn = data.aws_kms_key.ebs.arn

  depends_on = [aws_ebs_encryption_by_default.default]
}
