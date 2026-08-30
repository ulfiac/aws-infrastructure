locals {

  # sort availability_zones
  availability_zones_sorted = sort(data.aws_availability_zones.all.names)

  # select the first N based on availability_zone_count
  availability_zones_first_n = slice(local.availability_zones_sorted, 0, min(var.availability_zone_count, length(local.availability_zones_sorted)))

  # aws_account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.region

  igw_name = "${var.namespace}-${local.aws_region}"
  vpc_name = "${var.namespace}-${local.aws_region}"

  # prefix length of the block being carved up into public subnets
  public_cidr_block_prefix = tonumber(split("/", var.public_cidr_block)[1])

  # additional bits needed to go from the parent block to the desired public_subnet_mask
  public_subnet_newbits = var.public_subnet_mask - local.public_cidr_block_prefix

  # one public subnet per selected availability zone, keyed by AZ name for stable addressing
  public_subnets = {
    for idx, az in local.availability_zones_first_n : az => idx
  }

}
