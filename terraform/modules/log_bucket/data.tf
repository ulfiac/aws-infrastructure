data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "current" {
  count = var.enable_cloudtrail_logs ? 1 : 0
}

data "aws_region" "current" {}
