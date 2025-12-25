include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "component" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_components/billing.hcl"
  expose = true
}

terraform {
  source = "${include.component.locals.source_url}?ref=${include.component.locals.source_version}"
}

inputs = {}
