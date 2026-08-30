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
  log_bucket_arn     = dependency.log_bucket.outputs.log_bucket_arn
  namespace          = "eks"
  public_cidr_block  = "10.1.32.0/21"
  public_subnet_mask = 23
  verbose_output     = true
  vpc_cidr_block     = "10.1.32.0/19" # region block 2 of 8: 10.1.0.0/16 split into 8 /19s
}
