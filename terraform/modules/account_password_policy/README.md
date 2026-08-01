# account_password_policy

Terraform module to set the account password policy.

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
| [aws_iam_account_password_policy.password_policy](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/iam_account_password_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_users\_to\_change\_password | Whether to allow IAM users to change their own password. | `bool` | `true` | no |
| hard\_expiry | Whether to prevent IAM users from setting a new password after their password has expired. | `bool` | `false` | no |
| max\_password\_age | The maximum password age (in days) that an IAM user password is valid. | `number` | `180` | no |
| minimum\_password\_length | The minimum length to require for IAM user passwords. | `number` | `42` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
