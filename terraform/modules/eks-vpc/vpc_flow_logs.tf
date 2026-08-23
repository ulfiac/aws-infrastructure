resource "aws_flow_log" "vpc" {
  log_destination          = "${var.log_bucket_arn}/vpcflow"
  log_destination_type     = "s3"
  max_aggregation_interval = 600   # must be either 60 or 600
  traffic_type             = "ALL" # must be either ACCEPT, REJECT or ALL
  vpc_id                   = aws_vpc.vpc.id

  destination_options {
    file_format                = "parquet"
    hive_compatible_partitions = false
    per_hour_partition         = false
  }

  tags = {
    "Name" = "${var.namespace}-${local.aws_region}"
  }
}
