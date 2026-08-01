# account_password_policy

Terraform module to block public access to s3.

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
| [aws_s3_account_public_access_block.block_public_access](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/s3_account_public_access_block) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
