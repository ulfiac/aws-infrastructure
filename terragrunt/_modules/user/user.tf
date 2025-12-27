resource "aws_iam_user" "regular_user" {
  name          = local.user_name
  force_destroy = true
}

data "local_file" "pgp_public_key" {
  filename = abspath("./public_key_binary_base64encoded_new.gpg")
}

resource "aws_iam_user_login_profile" "regular_user" {
  pgp_key                 = data.local_file.pgp_public_key.content
  password_length         = 42
  password_reset_required = false
  user                    = aws_iam_user.regular_user.name
}

resource "aws_iam_user_group_membership" "regular_user" {
  groups = [aws_iam_group.default_group.name]
  user   = aws_iam_user.regular_user.name
}
