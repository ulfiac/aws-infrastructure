# create_aws_lambda

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.15.8 |
| archive | >= 2.7.1 |
| aws | 6.54.0 |

## Providers

| Name | Version |
|------|---------|
| archive | >= 2.7.1 |
| aws | 6.54.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.lambda_basic_execution_role](https://registry.terraform.io/providers/hashicorp/aws/6.54.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/6.54.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.hello_world_lambda](https://registry.terraform.io/providers/hashicorp/aws/6.54.0/docs/resources/lambda_function) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy.lambda_basic_execution_role](https://registry.terraform.io/providers/hashicorp/aws/6.54.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/6.54.0/docs/data-sources/iam_policy_document) | data source |

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
