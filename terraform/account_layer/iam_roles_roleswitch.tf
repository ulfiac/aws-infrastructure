data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowAssumeRoleIfMFA"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = [aws_iam_user.regular_user.arn]
      type        = "AWS"
    }
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_role" "admin" {
  name               = local.iam_role_name_admin
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "admin" {
  policy_arn = data.aws_iam_policy.admin_access.arn
  role       = aws_iam_role.admin.name
}

resource "aws_iam_role_policy_attachment" "billing" {
  policy_arn = data.aws_iam_policy.billing.arn
  role       = aws_iam_role.admin.name
}

resource "aws_iam_role" "power_user" {
  name               = local.iam_role_name_poweruser
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "power_user" {
  policy_arn = data.aws_iam_policy.power_user_access.arn
  role       = aws_iam_role.power_user.name
}
