locals {
  aws_default_tags = {
    created_by = "terragrunt/terraform"
    repo       = "infra"
  }

  providers = ["aws"]
}
