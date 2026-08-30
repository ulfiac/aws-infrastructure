# no state filter: keep the full, stable AZ list so transient AZ health doesn't reshuffle subnet identity
# opt-in-status filter excludes Local/Wavelength Zones, whose names can sort before regular AZ names
data "aws_availability_zones" "all" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_region" "current" {}
