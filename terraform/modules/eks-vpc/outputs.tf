output "data_availability_zones_available" {
  description = "The available AWS availability zones data source"
  value       = var.verbose_output ? data.aws_availability_zones.available : null
}

output "local_availability_zones_first_n" {
  description = "The first N availability zones based on availability_zone_count"
  value       = var.verbose_output ? local.availability_zones_first_n : null
}

output "local_availability_zones_sorted" {
  description = "The sorted availability zones"
  value       = var.verbose_output ? local.availability_zones_sorted : null
}

output "data_aws_region_current" {
  description = "The current AWS region data source"
  value       = var.verbose_output ? data.aws_region.current : null
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}
