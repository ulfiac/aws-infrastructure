# billing

Terraform module to create budget alarms and notifications.

reference:
https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-sns-policy.html

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
| [aws_budgets_budget.monthly_budget](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/budgets_budget) | resource |
| [aws_sns_topic.monthly_budget](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.monthly_budget](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_account\_email | The email address for SNS billing notifications. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
