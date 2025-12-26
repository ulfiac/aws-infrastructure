locals {

  standard_tags = {
    created_by = var.created_by
    project    = var.project
  }

  all_the_tags = merge(local.standard_tags, var.additional_tags)

}
