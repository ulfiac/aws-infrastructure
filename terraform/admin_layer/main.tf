locals {
  account_id = data.aws_caller_identity.current.account_id

  iam_group_name             = "default-group"
  iam_policy_name_mfa        = "enforce-mfa"
  iam_policy_name_roleswitch = "role-switch"
  iam_role_name_admin        = "role-switch-admin"
  iam_role_name_poweruser    = "role-switch-power-user"
  iam_user_name              = "actual"

}
