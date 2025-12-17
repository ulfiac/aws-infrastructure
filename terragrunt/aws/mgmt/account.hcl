# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# root.hcl configuration.
locals {
  aws_account_name = "mgmt"
  aws_account_id   = get_env("AWS_ACCOUNT_ID")
  environment_name = get_env("ENVIRONMENT_NAME")
}
