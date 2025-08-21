data "aws_iam_policy_document" "roleswitch" {
  statement {
    sid     = "AllowAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      aws_iam_role.admin.arn,
      aws_iam_role.power_user.arn,
    ]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "roleswitch" {
  name   = local.iam_policy_name_roleswitch
  policy = data.aws_iam_policy_document.roleswitch.json
}
