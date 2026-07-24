# create_rds_database

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.15.8 |
| aws | 6.56.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.56.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.aurora_serverless_v2](https://registry.terraform.io/providers/hashicorp/aws/6.56.0/docs/resources/db_subnet_group) | resource |
| [aws_rds_cluster.aurora_serverless_v2](https://registry.terraform.io/providers/hashicorp/aws/6.56.0/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.aurora_serverless_v2](https://registry.terraform.io/providers/hashicorp/aws/6.56.0/docs/resources/rds_cluster_instance) | resource |
| [aws_kms_key.rds](https://registry.terraform.io/providers/hashicorp/aws/6.56.0/docs/data-sources/kms_key) | data source |
| [aws_kms_key.secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/6.56.0/docs/data-sources/kms_key) | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/6.56.0/docs/data-sources/security_group) | data source |
| [aws_subnet.default](https://registry.terraform.io/providers/hashicorp/aws/6.56.0/docs/data-sources/subnet) | data source |
| [aws_subnets.default](https://registry.terraform.io/providers/hashicorp/aws/6.56.0/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/6.56.0/docs/data-sources/vpc) | data source |

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
