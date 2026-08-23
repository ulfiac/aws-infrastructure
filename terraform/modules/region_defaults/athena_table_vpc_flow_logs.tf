# must use a glue "catalog table" terraform resource because there is no athena terraform resource to create a table
resource "aws_glue_catalog_table" "vpc_flow_logs" {
  name          = local.athena_table_name_vpc_flow_logs
  database_name = aws_athena_database.logs.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "EXTERNAL"           = "TRUE"
    "classification"     = "parquet"
    "projection.enabled" = "true"

    "projection.year.type"  = "integer"
    "projection.year.range" = "2025,2100"

    "projection.month.type"   = "integer"
    "projection.month.range"  = "1,12"
    "projection.month.digits" = "2"

    "projection.day.type"   = "integer"
    "projection.day.range"  = "1,31"
    "projection.day.digits" = "2"

    "projection.hour.type"   = "integer"
    "projection.hour.range"  = "0,23"
    "projection.hour.digits" = "2"

    "storage.location.template" = "s3://${var.log_bucket_name}/vpcflow/AWSLogs/aws-account-id=${local.aws_account_id}/vpcflowlogs/aws-region=${local.aws_region}/year=$${year}/month=$${month}/day=$${day}/hour=$${hour}"
  }

  partition_keys {
    name = "year"
    type = "string"
  }
  partition_keys {
    name = "month"
    type = "string"
  }
  partition_keys {
    name = "day"
    type = "string"
  }
  partition_keys {
    name = "hour"
    type = "string"
  }

  storage_descriptor {
    bucket_columns            = []
    compressed                = false
    input_format              = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    location                  = "s3://${var.log_bucket_name}/vpcflow/AWSLogs/aws-account-id=${local.aws_account_id}/vpcflowlogs/aws-region=${local.aws_region}/"
    number_of_buckets         = -1
    output_format             = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    stored_as_sub_directories = false

    columns {
      name = "version"
      type = "int"
    }
    columns {
      name = "account_id"
      type = "string"
    }
    columns {
      name = "interface_id"
      type = "string"
    }
    columns {
      name = "srcaddr"
      type = "string"
    }
    columns {
      name = "dstaddr"
      type = "string"
    }
    columns {
      name = "srcport"
      type = "int"
    }
    columns {
      name = "dstport"
      type = "int"
    }
    columns {
      name = "protocol"
      type = "bigint"
    }
    columns {
      name = "packets"
      type = "bigint"
    }
    columns {
      name = "bytes"
      type = "bigint"
    }
    columns {
      name = "start"
      type = "bigint"
    }
    columns {
      name = "end"
      type = "bigint"
    }
    columns {
      name = "action"
      type = "string"
    }
    columns {
      name = "log_status"
      type = "string"
    }

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "parquet.compress" = "SNAPPY"
      }
    }
  }
}
