include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/credits.hcl"
  # We want to reference the variables from the included config in this configuration, so we expose it.
  expose = true
}

dependencies {
  paths = ["../vpc_default"]
}

terraform {
  source = "${include.component.locals.source_path}"
}

inputs = {}
