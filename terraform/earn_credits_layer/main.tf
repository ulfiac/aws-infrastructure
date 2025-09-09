locals {
  availability_zones = sort([for subnet in data.aws_subnet.default : subnet.availability_zone])
}
