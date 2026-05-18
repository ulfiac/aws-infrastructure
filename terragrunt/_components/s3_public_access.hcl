terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/modules/s3_public_access"
}

inputs = {}
