include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/credits.hcl"
}

dependencies {
  paths = ["../region_defaults"]
}
