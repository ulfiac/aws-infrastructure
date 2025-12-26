resource "aws_sns_topic" "earn_credits_setup_cost_budget" {
  name = "earn-credits-setup-cost-budget"
}

resource "aws_budgets_budget" "monthly" {
  name         = "earn-credits-setup-cost-budget"
  budget_type  = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  dynamic "notification" {
    for_each = [20, 40, 60, 80, 100]
    content {
      comparison_operator       = "GREATER_THAN"
      threshold                 = notification.value
      threshold_type            = "PERCENTAGE"
      notification_type         = "FORECASTED"
      subscriber_sns_topic_arns = [aws_sns_topic.earn_credits_setup_cost_budget.arn]
    }
  }
}
