data "archive_file" "lambda_converse_zip" {
  output_path = "${path.module}/scripts/lambda_converse.zip"
  source_file = "${path.module}/scripts/lambda_converse.py"
  type        = "zip"
}

data "archive_file" "lambda_invoke_model_zip" {
  output_path = "${path.module}/scripts/lambda_invoke_model.zip"
  source_file = "${path.module}/scripts/lambda_invoke_model.py"
  type        = "zip"
}

data "aws_iam_policy" "bedrock_full_access" {
  name = "AmazonBedrockFullAccess"
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

data "aws_bedrock_foundation_model" "nova_pro" {
  model_id = "amazon.nova-pro-v1:0"
}

data "aws_region" "current" {}
