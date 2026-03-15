output "log_bucket_name" {
  description = "The name of the S3 bucket for logs"
  value       = aws_s3_bucket.logs.bucket
}

output "log_bucket_arn" {
  description = "The ARN of the S3 bucket for logs"
  value       = aws_s3_bucket.logs.arn
}
