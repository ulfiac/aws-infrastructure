resource "aws_flow_log" "default_vpc" {
  log_destination          = "${aws_s3_bucket.logs.arn}/vpcflow"
  log_destination_type     = "s3"
  max_aggregation_interval = 600   # must be either 60 or 600
  traffic_type             = "ALL" # must be either ACCEPT, REJECT or ALL
  vpc_id                   = aws_default_vpc.adopted.id
}

data "aws_iam_policy_document" "default_vpc_flow_logs" {

  statement {
    sid       = "AWSLogDeliveryWrite"
    actions   = ["s3:PutObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.logs.arn}/vpcflow/AWSLogs/${local.aws_account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.aws_account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:${local.aws_region}:${local.aws_account_id}:*"]
    }

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}
