include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "component" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_components/repo.hcl"
  expose = true
}

inputs = {
  name        = "test-repo-guacamole"
  description = "This is a test repository"
}
