data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}

data "aws_iam_policy" "billing" {
  name = "Billing"
}

data "aws_iam_policy" "power_user_access" {
  name = "PowerUserAccess"
}

data "aws_iam_policy" "read_only_access" {
  name = "ReadOnlyAccess"
}

data "local_file" "pgp_key" {
  filename = abspath("./public_key_binary_base64encoded.gpg")
}
