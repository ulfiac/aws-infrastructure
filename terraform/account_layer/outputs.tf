output "encrypted_password" {
  value = aws_iam_user_login_profile.regular_user.encrypted_password
}

output "pgp_key_content_sha256_checksum" {
  value = data.local_file.pgp_key.content_sha256
}

output "subnet_AZs" {
  value = sort(local.availability_zones)
}

output "available_AZs" {
  value = sort(data.aws_availability_zones.available.names)
}
