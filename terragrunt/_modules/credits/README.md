# credits

Terraform module to earn AWS credits. There are five objectives each worth $20 (as of Dec 2025).

- Create a web app using AWS Lambda
- Create an Aurora or RDS database
- Launch an instance using EC2
- Setup a cost budget using AWS Budgets
- Use a foundation model in the Amazon Bedrock playground

This terraform module will create/destroy AWS resources to fulfill each objective depending on the input feature flags.  Each feature flag will toggle a sub-module - 1 for each of the 5 objectives listed above.

Reference:
https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-plans-activities.html

## Usage Instructions

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.1 |
| archive | >= 2.7.1 |
| aws | >= 6.24.0 |
| random | >= 3.7.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| create\_aws\_lambda | ./modules/create_aws_lambda | n/a |
| create\_rds\_database | ./modules/create_rds_database | n/a |
| launch\_ec2\_instance | ./modules/launch_ec2_instance | n/a |
| setup\_cost\_budget | ./modules/setup_cost_budget | n/a |
| use\_foundation\_model | ./modules/use_foundation_model | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_lambda | Flag to create a web app using AWS Lambda. | `bool` | `false` | no |
| create\_rds\_database | Flag to create an Aurora or RDS database. | `bool` | `false` | no |
| launch\_ec2\_instance | Flag to launch an instance using EC2. | `bool` | `false` | no |
| setup\_cost\_budget | Flag to setup a cost budget using AWS Budgets. | `bool` | `false` | no |
| use\_foundation\_model | Flag to use a foundation model in the Amazon Bedrock playground. | `bool` | `false` | no |

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
