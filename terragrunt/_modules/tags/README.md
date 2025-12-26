# tags

Terraform module to create a map of key/value pairs that serve as AWS tags.

## Usage Instructions

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.1 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tags | n/a | `map(string)` | `{}` | no |
| created\_by | n/a | `string` | `"terraform"` | no |
| project | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| additional\_tags | n/a |
| all\_the\_tags | n/a |
| standard\_tags | n/a |
<!-- END_TF_DOCS -->

## Contributing

## License

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
