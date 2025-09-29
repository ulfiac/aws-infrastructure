data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_basic_execution_role" {
  name               = "lambda_basic_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {
  role       = aws_iam_role.lambda_basic_execution_role.name
  policy_arn = data.aws_iam_policy.lambda_basic_execution_role.arn
}

data "archive_file" "lambda_zip" {
  output_path = "${path.module}/lambda_function.zip"
  source_file = "${path.module}/lambda_code.py"
  type        = "zip"
}

#trivy:ignore:AVD-AWS-0066 (LOW): Function does not have tracing enabled.
resource "aws_lambda_function" "hello_world_lambda" {
  function_name = "hello-world-lambda"
  role          = aws_iam_role.lambda_basic_execution_role.arn

  handler      = "lambda_function.lambda_handler"
  package_type = "Zip"
  runtime      = "python3.12"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}
