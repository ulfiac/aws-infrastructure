#trivy:ignore:AVD-AWS-0123 (MEDIUM): Multi-Factor authentication is not enforced for group
resource "aws_iam_group" "default_group" {
  name = "ulfiacDefaultGroup"
}

resource "aws_iam_group_policy_attachment" "read_only_access" {
  group      = aws_iam_group.default_group.name
  policy_arn = data.aws_iam_policy.read_only_access.arn
}

resource "aws_iam_group_policy_attachment" "roleswitch" {
  group      = aws_iam_group.default_group.name
  policy_arn = aws_iam_policy.roleswitch.arn
}
