# cloudtrail

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.15.7 |
| aws | 6.55.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.55.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.multi_region_trail](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_metric_filter.console_login_without_mfa](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.root_user](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_metric_alarm.console_login_without_mfa](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.root_user](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_glue_catalog_table.cloudtrail_logs](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/glue_catalog_table) | resource |
| [aws_iam_role.cloudtrail_to_cloudwatch_role](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cloudtrail_to_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/iam_role_policy) | resource |
| [aws_sns_topic.alarms](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.alarms](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cloudtrail_to_cloudwatch_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_to_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/region) | data source |
| [aws_regions.enabled](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| athena\_database\_name | The name of the Athena database where the table for CloudTrail logs will be created. | `string` | n/a | yes |
| aws\_account\_email | The email address for SNS alarm notifications. | `string` | n/a | yes |
| log\_bucket\_name | The name of the S3 bucket to store CloudTrail logs. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
