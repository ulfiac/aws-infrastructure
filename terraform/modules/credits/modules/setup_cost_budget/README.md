# setup_cost_budget

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.15.8 |
| aws | 6.54.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.54.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.monthly](https://registry.terraform.io/providers/hashicorp/aws/6.54.0/docs/resources/budgets_budget) | resource |
| [aws_sns_topic.earn_credits_setup_cost_budget](https://registry.terraform.io/providers/hashicorp/aws/6.54.0/docs/resources/sns_topic) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Contributing

## License

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
