data "aws_iam_policy_document" "roleswitch" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      aws_iam_role.admin_role.arn,
      aws_iam_role.power_user_role.arn,
    ]
  }
}

resource "aws_iam_policy" "roleswitch" {
  name   = "roleswitch"
  policy = data.aws_iam_policy_document.roleswitch.json
}
