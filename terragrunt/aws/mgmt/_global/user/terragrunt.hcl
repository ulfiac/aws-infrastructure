include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "component" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_components/user.hcl"
  expose = true
}

dependencies {
  paths = ["../account_password_policy"]
}

terraform {
  source = "${include.component.locals.source_path}"
}

inputs = {}
