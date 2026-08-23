resource "aws_flow_log" "default_vpc" {
  log_destination          = "${var.log_bucket_arn}/vpcflow"
  log_destination_type     = "s3"
  max_aggregation_interval = 600   # must be either 60 or 600
  traffic_type             = "ALL" # must be either ACCEPT, REJECT or ALL
  vpc_id                   = aws_default_vpc.adopted.id

  destination_options {
    file_format                = "parquet"
    hive_compatible_partitions = true
    per_hour_partition         = true
  }

  tags = {
    "Name" = "default-${local.aws_region}"
  }
}
