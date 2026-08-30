output "data_availability_zones_all" {
  description = "All AWS availability zones the account has access to (unfiltered by state)"
  value       = var.verbose_output ? data.aws_availability_zones.all : null
}

output "data_aws_region_current" {
  description = "The current AWS region data source"
  value       = var.verbose_output ? data.aws_region.current : null
}

output "local_availability_zones_first_n" {
  description = "The first N availability zones based on availability_zone_count"
  value       = var.verbose_output ? local.availability_zones_first_n : null
}

output "local_availability_zones_sorted" {
  description = "The sorted availability zones"
  value       = var.verbose_output ? local.availability_zones_sorted : null
}

output "local_public_subnets" {
  description = "Map of availability zone to CIDR sub-block index used to carve each public subnet"
  value       = var.verbose_output ? local.public_subnets : null
}

output "local_public_cidr_block_prefix" {
  description = "The prefix length of the parent public_cidr_block (not the carved subnets' prefix)"
  value       = var.verbose_output ? local.public_cidr_block_prefix : null
}

output "local_public_subnet_newbits" {
  description = "The number of new bits for the local public subnets"
  value       = var.verbose_output ? local.public_subnet_newbits : null
}

output "public_route_table_id" {
  description = "The ID of the shared public route table"
  value       = aws_route_table.public.id
}

output "public_subnet_ids" {
  description = "Map of availability zone to public subnet ID"
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}
