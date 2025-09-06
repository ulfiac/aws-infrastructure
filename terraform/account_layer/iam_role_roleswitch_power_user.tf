data "aws_iam_policy_document" "assume_role_power_user" {
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

resource "aws_iam_role" "power_user" {
  name               = local.iam_role_name_poweruser
  assume_role_policy = data.aws_iam_policy_document.assume_role_power_user.json
}

resource "aws_iam_role_policy_attachment" "power_user" {
  policy_arn = data.aws_iam_policy.power_user_access.arn
  role       = aws_iam_role.power_user.name
}
