resource "aws_organizations_account" "prod" {
  for_each = local.prod_accounts

  name  = each.key
  email = each.value

  close_on_deletion          = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workloads_prod.id
  role_name                  = "OrganizationAccountAccessRole"
}

resource "aws_organizations_account" "test" {
  for_each = local.test_accounts

  name  = each.key
  email = each.value

  close_on_deletion          = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workloads_test.id
  role_name                  = "OrganizationAccountAccessRole"
}
