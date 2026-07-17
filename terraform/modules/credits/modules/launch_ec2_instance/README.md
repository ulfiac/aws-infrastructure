# launch_ec2_instance

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.15.8 |
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
| [aws_instance.ec2_instance](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/instance) | resource |
| [aws_ami.most_recent_al2023](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/ami) | data source |
| [aws_kms_key.ebs](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/kms_key) | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/security_group) | data source |
| [aws_subnets.default](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/data-sources/vpc) | data source |

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
