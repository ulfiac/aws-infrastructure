# use_foundation_model

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.15.8 |
| archive | 2.8.0 |
| aws | 6.57.1 |
| random | 3.9.0 |

## Providers

| Name | Version |
|------|---------|
| archive | 2.8.0 |
| aws | 6.57.1 |
| random | 3.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.lambda_basic_execution_role](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.bedrock_full_access_policy](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.earn_aws_credit_converse](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/resources/lambda_function) | resource |
| [aws_lambda_function.earn_aws_credit_invoke_model](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/resources/lambda_function) | resource |
| [aws_lambda_invocation.converse](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/resources/lambda_invocation) | resource |
| [aws_lambda_invocation.invoke_model](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/resources/lambda_invocation) | resource |
| [random_integer.converse_first_term](https://registry.terraform.io/providers/hashicorp/random/3.9.0/docs/resources/integer) | resource |
| [random_integer.converse_second_term](https://registry.terraform.io/providers/hashicorp/random/3.9.0/docs/resources/integer) | resource |
| [random_integer.invoke_model_first_term](https://registry.terraform.io/providers/hashicorp/random/3.9.0/docs/resources/integer) | resource |
| [random_integer.invoke_model_second_term](https://registry.terraform.io/providers/hashicorp/random/3.9.0/docs/resources/integer) | resource |
| [archive_file.lambda_converse_zip](https://registry.terraform.io/providers/hashicorp/archive/2.8.0/docs/data-sources/file) | data source |
| [archive_file.lambda_invoke_model_zip](https://registry.terraform.io/providers/hashicorp/archive/2.8.0/docs/data-sources/file) | data source |
| [aws_bedrock_foundation_model.nova_pro](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/data-sources/bedrock_foundation_model) | data source |
| [aws_iam_policy.bedrock_full_access](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.lambda_basic_execution_role](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.57.1/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| converse | result received from calling foundation module using converse method |
| invoke\_model | result received from calling foundation module using invoke\_model method |
<!-- END_TF_DOCS -->

## Contributing

## License

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
