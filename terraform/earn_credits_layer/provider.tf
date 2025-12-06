provider "aws" {
  region = var.aws_region

  default_tags {
    tags = module.tags.all_the_tags
  }
}

provider "archive" {}

module "tags" {
  # tflint-ignore: terraform_module_pinned_source
  source  = "git::https://github.com/ulfiac/aws-tags.git"
  project = "aws-infrastructure"
  additional_tags = {
    layer = "earn_credits_layer"
  }
}
