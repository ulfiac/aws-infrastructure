resource "aws_iam_user" "admin_user" {
  name          = "ulfiac"
  force_destroy = true
}

data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "admin_user" {
  user       = aws_iam_user.admin_user.name
  policy_arn = data.aws_iam_policy.admin_access.arn
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
