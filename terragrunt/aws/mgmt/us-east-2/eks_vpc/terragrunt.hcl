include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/eks_vpc.hcl"
}

dependency "log_bucket" {
  config_path = "../log_bucket"

  mock_outputs = {
    log_bucket_arn = "arn:aws:s3:::logs-${include.root.locals.merged_vars.aws_account_id}-${include.root.locals.merged_vars.aws_region}"
  }
}

inputs = {
  log_bucket_arn = dependency.log_bucket.outputs.log_bucket_arn
  namespace      = "eks"
  verbose_output = true
  vpc_cidr_block = "10.2.0.0/16"
}
