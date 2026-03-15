output "adopted_subnets" {
  description = "The adopted default subnets"
  value       = var.verbose_output ? aws_default_subnet.adopted : null
}

output "adopted_vpc" {
  description = "The adopted default VPC"
  value       = var.verbose_output ? aws_default_vpc.adopted : null
}

output "data_availability_zones_available" {
  description = "The available AWS availability zones data source"
  value       = var.verbose_output ? data.aws_availability_zones.available : null
}

output "data_aws_region_current" {
  description = "The current AWS region data source"
  value       = var.verbose_output ? data.aws_region.current : null
}

output "data_aws_subnet_default" {
  description = "The default subnet data source"
  value       = var.verbose_output ? data.aws_subnet.default : null
}

output "data_aws_subnets_default" {
  description = "The default subnets data source"
  value       = var.verbose_output ? data.aws_subnets.default : null
}

output "data_aws_vpc_default" {
  description = "The default VPC data source"
  value       = var.verbose_output ? data.aws_vpc.default : null
}

output "local_availability_zones" {
  description = "The calculated availability zones"
  value       = var.verbose_output ? local.availability_zones : null
}

output "local_region" {
  description = "The calculated region"
  value       = var.verbose_output ? local.aws_region : null
}

output "athena_database_name" {
  description = "The name of the Athena database for logs"
  value       = aws_athena_database.logs.name
}
