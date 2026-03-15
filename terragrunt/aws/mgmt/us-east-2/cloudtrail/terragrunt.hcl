include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/cloudtrail.hcl"
}

dependency "log_bucket" {
  config_path = "../log_bucket"

  mock_outputs = {
    log_bucket_name = "log-bucket-${include.root.locals.merged_vars.aws_account_id}-${include.root.locals.merged_vars.aws_region}"
  }
}

dependency "region_defaults" {
  config_path = "../region_defaults"

  mock_outputs = {
    athena_database_name = "logs_${replace(include.root.locals.merged_vars.aws_region, "-", "_")}"
  }
}

inputs = {
  athena_database_name = dependency.region_defaults.outputs.athena_database_name
  log_bucket_name      = dependency.log_bucket.outputs.log_bucket_name
}
