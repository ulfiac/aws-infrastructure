# no state filter: keep the full, stable AZ list so transient AZ health doesn't reshuffle subnet identity
data "aws_availability_zones" "all" {}

data "aws_region" "current" {}
