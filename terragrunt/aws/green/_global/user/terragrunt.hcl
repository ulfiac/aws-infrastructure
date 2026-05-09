include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/user.hcl"
}

dependencies {
  paths = ["../account_password_policy"]
}
