locals {
  source_path = "${dirname(find_in_parent_folders("root.hcl"))}/_modules/account_password_policy"
}

inputs = {}
