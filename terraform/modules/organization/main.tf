locals {
  prod_accounts = {
    "prod" = "${var.email_prefix}+aws-prod@${var.email_domain}"
  }

  test_accounts = {
    "test" = "${var.email_prefix}+aws-test@${var.email_domain}"
  }
}
