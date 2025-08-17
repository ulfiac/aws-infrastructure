data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
      type        = "AWS"
    }

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_role" "admin_role" {
  name               = "ulfiacAdmin"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "admin" {
  policy_arn = data.aws_iam_policy.admin_access.arn
  role       = aws_iam_role.admin_role.name
}

resource "aws_iam_role_policy_attachment" "billing" {
  policy_arn = data.aws_iam_policy.billing.arn
  role       = aws_iam_role.admin_role.name
}

resource "aws_iam_role" "power_user_role" {
  name               = "ulfiacPowerUser"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "power_user" {
  policy_arn = data.aws_iam_policy.power_user_access.arn
  role       = aws_iam_role.power_user_role.name
}
