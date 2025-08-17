data "aws_iam_policy" "admin_access_policy" {
  name = "AdministratorAccess"
}

resource "aws_iam_group" "admin_access" {
  name = "ulfiacAdminAccess"
}

resource "aws_iam_group_policy_attachments_exclusive" "admin_access" {
  group_name  = aws_iam_group.admin_access.name
  policy_arns = [data.aws_iam_policy.admin_access_policy.arn]
}

resource "aws_iam_user" "admin_user" {
  name          = "ulfiac"
  force_destroy = true
}

data "local_file" "pgp_key" {
  filename = abspath("./public_key_binary_base64encoded.gpg")
}

resource "aws_iam_user_login_profile" "admin_user" {
  pgp_key                 = data.local_file.pgp_key.content
  password_length         = 42
  password_reset_required = true
  user                    = aws_iam_user.admin_user.name
}

resource "aws_iam_group_membership" "admin_access" {
  name  = "admin-access-group-membership-exclusive"
  group = aws_iam_group.admin_access.name
  users = [aws_iam_user.admin_user]
}
