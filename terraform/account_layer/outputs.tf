output "encrypted_password" {
  value = aws_iam_user_login_profile.regular_user.encrypted_password
}

output "pgp_key_content_sha256_checksum" {
  value = data.local_file.pgp_key.content_sha256
}
