# eks-vpc

Terraform module to create the VPC networking components needed for EKS.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.15.8 |
| aws | 6.58.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.58.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_flow_log.vpc](https://registry.terraform.io/providers/hashicorp/aws/6.58.0/docs/resources/flow_log) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/6.58.0/docs/resources/internet_gateway) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/6.58.0/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/6.58.0/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.58.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zone\_count | The number of availability zones to use for the VPC. | `number` | `3` | no |
| log\_bucket\_arn | ARN of the S3 bucket to store logs | `string` | n/a | yes |
| namespace | The namespace for the VPC. | `string` | n/a | yes |
| verbose\_output | Enable verbose output for debugging purposes. | `bool` | `false` | no |
| vpc\_cidr\_block | The CIDR block for the VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| data\_availability\_zones\_available | The available AWS availability zones data source |
| data\_aws\_region\_current | The current AWS region data source |
| local\_availability\_zones\_first\_n | The first N availability zones based on availability\_zone\_count |
| local\_availability\_zones\_sorted | The sorted availability zones |
| vpc\_id | The ID of the VPC |
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
