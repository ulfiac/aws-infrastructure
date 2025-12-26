output "additional_tags" {
  description = "The additional tags passed as input"
  value       = var.additional_tags
}

output "all_the_tags" {
  description = "All the tags merged into a single map"
  value       = local.all_the_tags
}

output "standard_tags" {
  description = "The standard tags pre-defined by the module"
  value       = local.standard_tags
}
