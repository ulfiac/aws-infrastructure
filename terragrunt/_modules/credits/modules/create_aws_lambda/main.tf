resource "aws_iam_role" "lambda_basic_execution_role" {
  name               = "earn-credits-create-aws-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {
  role       = aws_iam_role.lambda_basic_execution_role.name
  policy_arn = data.aws_iam_policy.lambda_basic_execution_role.arn
}

#trivy:ignore:AVD-AWS-0066 (LOW): Function does not have tracing enabled.
resource "aws_lambda_function" "hello_world_lambda" {
  function_name = "hello-world-lambda"
  role          = aws_iam_role.lambda_basic_execution_role.arn

  handler      = "lambda_code.lambda_handler"
  package_type = "Zip"
  runtime      = "python3.12"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}
