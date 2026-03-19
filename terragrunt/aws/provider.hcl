locals {
  aws_default_tags = {
    created_by = "terragrunt/terraform"
    repo       = "infra"
  }

  email_domain = get_env("TG_VAR_EMAIL_DOMAIN")
  email_prefix = get_env("TG_VAR_EMAIL_PREFIX")

  providers = ["aws"]
}
