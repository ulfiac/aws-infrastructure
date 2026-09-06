# eks-vpc

Terraform module to create the VPC networking components needed for EKS.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.15.9 |
| aws | 6.61.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.61.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_flow_log.vpc](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/flow_log) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/internet_gateway) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/route) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/route_table_association) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/resources/vpc) | resource |
| [aws_availability_zones.all](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.61.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zone\_count | The number of availability zones to use for the VPC. | `number` | `3` | no |
| log\_bucket\_arn | ARN of the S3 bucket to store logs | `string` | n/a | yes |
| namespace | The namespace for the VPC. | `string` | n/a | yes |
| public\_cidr\_block | The CIDR block to carve up into public subnets, one per availability zone. | `string` | n/a | yes |
| public\_subnet\_mask | The subnet mask (prefix length) used when carving public\_cidr\_block into individual public subnets, e.g. 24 for a /24. | `number` | n/a | yes |
| verbose\_output | Enable verbose output for debugging purposes. | `bool` | `false` | no |
| vpc\_cidr\_block | The CIDR block for the VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| data\_availability\_zones\_all | All AWS availability zones the account has access to (unfiltered by state) |
| data\_aws\_region\_current | The current AWS region data source |
| local\_availability\_zones\_first\_n | The first N availability zones based on availability\_zone\_count |
| local\_availability\_zones\_sorted | The sorted availability zones |
| local\_public\_cidr\_block\_prefix | The prefix length of the parent public\_cidr\_block (not the carved subnets' prefix) |
| local\_public\_subnet\_newbits | The number of new bits for the local public subnets |
| local\_public\_subnets | Map of availability zone to CIDR sub-block index used to carve each public subnet |
| public\_route\_table\_id | The ID of the shared public route table |
| public\_subnet\_ids | Map of availability zone to public subnet ID |
| vpc\_id | The ID of the VPC |
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
