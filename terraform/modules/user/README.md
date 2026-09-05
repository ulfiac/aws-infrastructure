# user

Terraform module to create various resources to enable logging into AWS with a regular user rather than the root user.  These resources include:

- user
- default group which the user is made a member of
- aws-managed permission policy attached to the default group to allow read-only access
- customer-inline permissions policy attached to the default group to enforce mfa
- customer-inline permissions policy attached to the default group to control role assumption/switching
- role to assume for admin access
- role to assume for power user access

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.15.8 |
| aws | 6.61.0 |
| local | 2.9.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.61.0 |
| local | 2.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_group.default_group](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_group) | resource |
| [aws_iam_group_policy.enforce_mfa](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy.roleswitch](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy_attachment.view_only_access](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_role.admin](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role.power_user](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.admin](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.billing](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.power_user](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.regular_user](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.regular_user](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_login_profile.regular_user](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/iam_user_login_profile) | resource |
| [aws_iam_policy.admin_access](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.billing](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.power_user_access](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.view_only_access](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.assume_role_admin](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_power_user](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.enforce_mfa](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.roleswitch](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/data-sources/iam_policy_document) | data source |
| [local_file.pgp_public_key](https://registry.terraform.io/providers/hashicorp/local/2.9.0/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| default\_group\_name | The name of the default group. | `string` | `"default-group"` | no |
| default\_group\_policy\_name\_enforce\_mfa | The name of the default group policy to enforce MFA. | `string` | `"enforce-mfa"` | no |
| default\_group\_policy\_name\_roleswitch | The name of the default group policy for role switching. | `string` | `"role-switch"` | no |
| role\_max\_session\_duration | The roles' maximum session duration in seconds. | `number` | `43200` | no |
| role\_name\_roleswitch\_admin | The name of the role for admin role switching. | `string` | `"role-switch-admin"` | no |
| role\_name\_roleswitch\_poweruser | The name of the role for power user role switching. | `string` | `"role-switch-poweruser"` | no |
| user\_name | The name of the user to be created. | `string` | `"actual"` | no |
| user\_password\_length | The length of the user's password. | `number` | `42` | no |
| user\_password\_reset\_required | Whether the user is required to reset their password on first login. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| encrypted\_password | encrypted password of the regular user |
| pgp\_public\_key\_content\_sha256\_checksum | SHA256 checksum of the PGP public key content |
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
