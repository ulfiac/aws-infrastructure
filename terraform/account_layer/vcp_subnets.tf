resource "aws_default_subnet" "modified" {
  for_each                = toset(local.availability_zones)
  availability_zone       = each.value
  map_public_ip_on_launch = false
  force_destroy           = false

  tags = {
    "Name" = "default-${each.value}"
  }
}
