resource "aws_organizations_organizational_unit" "workloads" {
  name      = "workloads"
  parent_id = aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads_prod" {
  name      = "prodOU"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workloads_test" {
  name      = "testOU"
  parent_id = aws_organizations_organizational_unit.workloads.id
}
