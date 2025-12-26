output "converse" {
  value = var.use_foundation_model ? module.use_foundation_model[0].converse : null
}

output "invoke_model" {
  value = var.use_foundation_model ? module.use_foundation_model[0].invoke_model : null
}
