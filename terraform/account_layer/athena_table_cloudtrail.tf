# must use a glue "catalog table" terraform resource because there is no athena terraform resource to create a table
resource "aws_glue_catalog_table" "cloudtrail_logs" {
  name          = local.athena_table_name_cloudtrail
  database_name = aws_athena_database.logs.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "EXTERNAL"                     = "TRUE",
    "projection.enabled"           = "true",
    "projection.day.format"        = "yyyy/MM/dd",
    "projection.day.interval"      = "1",
    "projection.day.interval.unit" = "DAYS",
    "projection.day.range"         = "2025/01/01,NOW",
    "projection.day.type"          = "date",
    "projection.region.type"       = "enum"
    "projection.region.values"     = "us-east-1,us-west-1,us-east-2,us-west-2"
    "storage.location.template"    = "s3://${aws_s3_bucket.logs.bucket}/${local.s3_key_prefix_cloudtrail}/AWSLogs/${local.account_id}/CloudTrail/$${region}/$${day}"
  }

  partition_keys {
    name = "day"
    type = "string"
  }

  partition_keys {
    name = "region"
    type = "string"
  }

  storage_descriptor {
    bucket_columns            = []
    compressed                = false
    input_format              = "com.amazon.emr.cloudtrail.CloudTrailInputFormat"
    location                  = "s3://${aws_s3_bucket.logs.bucket}/${local.s3_key_prefix_cloudtrail}/AWSLogs/"
    number_of_buckets         = -1
    output_format             = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    stored_as_sub_directories = false

    columns {
      name = "eventversion"
      type = "string"
    }
    columns {
      name = "useridentity"
      type = "struct<type:string,principalId:string,arn:string,accountId:string,invokedBy:string,accessKeyId:string,userName:string,onbehalfof:struct<userid:string,identitystorearn:string>,sessionContext:struct<attributes:struct<mfaAuthenticated:string,creationDate:string>,sessionIssuer:struct<type:string,principalId:string,arn:string,accountId:string,userName:string>,ec2roledelivery:string,webidfederationdata:struct<federatedprovider:string,attributes:map<string,string>>>>"
    }
    columns {
      name = "eventtime"
      type = "string"
    }
    columns {
      name = "eventsource"
      type = "string"
    }
    columns {
      name = "eventname"
      type = "string"
    }
    columns {
      name = "awsregion"
      type = "string"
    }
    columns {
      name = "sourceipaddress"
      type = "string"
    }
    columns {
      name = "useragent"
      type = "string"
    }
    columns {
      name = "errorcode"
      type = "string"
    }
    columns {
      name = "errormessage"
      type = "string"
    }
    columns {
      name = "requestparameters"
      type = "string"
    }
    columns {
      name = "responseelements"
      type = "string"
    }
    columns {
      name = "additionaleventdata"
      type = "string"
    }
    columns {
      name = "requestid"
      type = "string"
    }
    columns {
      name = "eventid"
      type = "string"
    }
    columns {
      name = "readonly"
      type = "string"
    }
    columns {
      name = "resources"
      type = "array<struct<arn:string,accountId:string,type:string>>"
    }
    columns {
      name = "eventtype"
      type = "string"
    }
    columns {
      name = "apiversion"
      type = "string"
    }
    columns {
      name = "recipientaccountid"
      type = "string"
    }
    columns {
      name = "serviceeventdetails"
      type = "string"
    }
    columns {
      name = "sharedeventid"
      type = "string"
    }
    columns {
      name = "vpcendpointid"
      type = "string"
    }
    columns {
      name = "vpcendpointaccountid"
      type = "string"
    }
    columns {
      name = "eventcategory"
      type = "string"
    }
    columns {
      name = "addendum"
      type = "struct<reason:string,updatedfields:string,originalrequestid:string,originaleventid:string>"
    }
    columns {
      name = "sessioncredentialfromconsole"
      type = "string"
    }
    columns {
      name = "edgedevicedetails"
      type = "string"
    }
    columns {
      name = "tlsdetails"
      type = "struct<tlsversion:string,ciphersuite:string,clientprovidedhostheader:string>"
    }

    ser_de_info {
      serialization_library = "org.apache.hive.hcatalog.data.JsonSerDe"
    }

  }

}
