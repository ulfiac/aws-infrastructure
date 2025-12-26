output "adopted_subnets" {
  description = "The adopted default subnets"
  value       = aws_default_subnet.adopted
}

output "adopted_vpc" {
  description = "The adopted default VPC"
  value       = aws_default_vpc.adopted
}

output "data_availability_zones_available" {
  description = "The available AWS availability zones data source"
  value       = data.aws_availability_zones.available
}

output "data_aws_region_current" {
  description = "The current AWS region data source"
  value       = data.aws_region.current
}

output "data_aws_subnet_default" {
  description = "The default subnet data source"
  value       = data.aws_subnet.default
}

output "data_aws_subnets_default" {
  description = "The default subnets data source"
  value       = data.aws_subnets.default
}

output "data_aws_vpc_default" {
  description = "The default VPC data source"
  value       = data.aws_vpc.default
}

output "local_availability_zones" {
  description = "The calculated availability zones"
  value       = local.availability_zones
}

output "local_region" {
  description = "The calculated region"
  value       = local.region
}
