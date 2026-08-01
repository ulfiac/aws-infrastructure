# tags

Terraform module to create a map of key/value pairs that serve as AWS tags.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.15.8 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tags | Additional tags to merge with standard tags | `map(string)` | `{}` | no |
| created\_by | Name of the entity or user that created the resource | `string` | `"terraform"` | no |
| repo | Name of the repository that created the resource | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| additional\_tags | The additional tags passed as input |
| all\_the\_tags | All the tags merged into a single map |
| standard\_tags | The standard tags pre-defined by the module |
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
