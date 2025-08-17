resource "aws_iam_user" "admin_user" {
  name          = "ulfiacUser"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "admin_user" {
  pgp_key                 = data.local_file.pgp_key.content
  password_length         = 42
  password_reset_required = true
  user                    = aws_iam_user.admin_user.name
}

resource "aws_iam_user_group_membership" "default_group" {
  groups = [aws_iam_group.default_group.name]
  user   = aws_iam_user.admin_user.name
}
