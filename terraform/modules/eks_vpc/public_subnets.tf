resource "aws_subnet" "public" {
  for_each = local.public_subnets

  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.public_cidr_block, local.public_subnet_newbits, each.value)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name                     = "${var.namespace}-public-${each.key}"
    "kubernetes.io/role/elb" = "1"
  }
}
