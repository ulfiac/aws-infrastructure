resource "aws_iam_group" "default_group" {
  name = local.iam_group_name
}

resource "aws_iam_group_policy_attachment" "read_only_access" {
  group      = aws_iam_group.default_group.name
  policy_arn = data.aws_iam_policy.read_only_access.arn
}
