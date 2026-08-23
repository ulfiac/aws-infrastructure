locals {

  # sort availability_zones
  availability_zones_sorted = sort(data.aws_availability_zones.available.names)

  # select the first N based on availability_zone_count
  availability_zones_first_n = slice(local.availability_zones_sorted, 0, min(var.availability_zone_count, length(local.availability_zones_sorted)))

  # aws_account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.region

  igw_name = "${var.namespace}-${local.aws_region}"
  vpc_name = "${var.namespace}-${local.aws_region}"

}
