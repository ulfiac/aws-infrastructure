locals {
  availability_zones = [for subnet in data.aws_subnet.default : subnet.availability_zone]
  region             = data.aws_region.current.region
}

resource "aws_default_subnet" "adopted" {
  for_each                = toset(local.availability_zones)
  availability_zone       = each.value
  map_public_ip_on_launch = false
  force_destroy           = false

  tags = {
    "Name" = "default-${each.value}"
  }

  depends_on = [aws_default_vpc.adopted]
}

#trivy:ignore:AVD-AWS-0101 (HIGH): Default VPC is used.
#trivy:ignore:AVD-AWS-0178 (MEDIUM): VPC does not have VPC Flow Logs enabled.
resource "aws_default_vpc" "adopted" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  force_destroy        = false

  tags = {
    "Name" = "default-${local.region}"
  }
}
