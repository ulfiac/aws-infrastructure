output "encrypted_password" {
  value = aws_iam_user_login_profile.admin_user.encrypted_password
}

output "local_file_pgp_key_content_sha256_checksum" {
  value = data.local_file.pgp_key.content_sha256
}
