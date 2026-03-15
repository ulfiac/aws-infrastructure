resource "aws_athena_workgroup" "logs" {
  name          = local.athena_workgroup_name
  state         = "ENABLED"
  force_destroy = true

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${var.log_bucket_name}/athena/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}

resource "aws_athena_database" "logs" {
  name          = local.athena_database_name
  bucket        = var.log_bucket_name
  force_destroy = true
  workgroup     = aws_athena_workgroup.logs.name

  encryption_configuration {
    encryption_option = "SSE_S3"
  }
}
