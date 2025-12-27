data "aws_iam_policy_document" "assume_role_admin" {
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
  name               = local.role_name_roleswitch_admin
  assume_role_policy = data.aws_iam_policy_document.assume_role_admin.json
}

data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "admin" {
  policy_arn = data.aws_iam_policy.admin_access.arn
  role       = aws_iam_role.admin.name
}

data "aws_iam_policy" "billing" {
  name = "Billing"
}

resource "aws_iam_role_policy_attachment" "billing" {
  policy_arn = data.aws_iam_policy.billing.arn
  role       = aws_iam_role.admin.name
}
