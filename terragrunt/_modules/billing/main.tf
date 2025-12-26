locals {
  aws_account_id            = data.aws_caller_identity.current.account_id
  aws_region                = data.aws_region.current.region
  billing_budget_name       = "monthly-budget"
  billing_budget_thresholds = [20, 40, 60, 80, 100]
  sns_endpoint_email        = var.email
  sns_topic_name            = "monthly-budget"
}

#trivy:ignore:AVD-AWS-0136 (HIGH): Topic encryption does not use a customer managed key.
resource "aws_sns_topic" "monthly_budget" {
  name              = local.sns_topic_name
  policy            = data.aws_iam_policy_document.sns_topic_policy.json
  kms_master_key_id = data.aws_kms_key.sns.key_id
}

resource "aws_sns_topic_subscription" "monthly_budget_via_email" {
  topic_arn = aws_sns_topic.monthly_budget.arn
  protocol  = "email"
  endpoint  = local.sns_endpoint_email
}

resource "aws_budgets_budget" "monthly_budget" {
  name         = local.billing_budget_name
  budget_type  = "COST"
  limit_amount = "1"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  dynamic "notification" {
    for_each = local.billing_budget_thresholds
    content {
      comparison_operator       = "GREATER_THAN"
      threshold                 = notification.value
      threshold_type            = "PERCENTAGE"
      notification_type         = "FORECASTED"
      subscriber_sns_topic_arns = [aws_sns_topic.monthly_budget.arn]
    }
  }

  depends_on = [
    aws_sns_topic.monthly_budget,
    aws_sns_topic_subscription.monthly_budget_via_email
  ]
}
