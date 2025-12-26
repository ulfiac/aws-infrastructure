data "archive_file" "lambda_zip" {
  output_path = "${path.module}/scripts/lambda_function.zip"
  source_file = "${path.module}/scripts/lambda_code.py"
  type        = "zip"
}

data "aws_iam_policy" "lambda_basic_execution_role" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
