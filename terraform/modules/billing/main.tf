locals {
  aws_account_id               = data.aws_caller_identity.current.account_id
  aws_region                   = data.aws_region.current.region
  budget_name                  = "monthly-budget"
  budget_thresholds_actual     = [20, 40, 60, 80, 100]
  budget_thresholds_forecasted = [100, 150, 200]
  sns_topic_name               = "monthly-budget"
}

#trivy:ignore:AVD-AWS-0095 (HIGH): Topic does not have encryption enabled.
resource "aws_sns_topic" "monthly_budget" {
  name   = local.sns_topic_name
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "monthly_budget" {
  topic_arn = aws_sns_topic.monthly_budget.arn
  protocol  = "email"
  endpoint  = var.aws_account_email
}

resource "aws_budgets_budget" "monthly_budget" {
  name         = local.budget_name
  budget_type  = "COST"
  limit_amount = "1"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_types {
    include_credit = false
  }

  dynamic "notification" {
    for_each = local.budget_thresholds_actual
    content {
      comparison_operator       = "GREATER_THAN"
      threshold                 = notification.value
      threshold_type            = "PERCENTAGE"
      notification_type         = "ACTUAL"
      subscriber_sns_topic_arns = [aws_sns_topic.monthly_budget.arn]
    }
  }

  dynamic "notification" {
    for_each = local.budget_thresholds_forecasted
    content {
      comparison_operator       = "GREATER_THAN"
      threshold                 = notification.value
      threshold_type            = "PERCENTAGE"
      notification_type         = "FORECASTED"
      subscriber_sns_topic_arns = [aws_sns_topic.monthly_budget.arn]
    }
  }
}
