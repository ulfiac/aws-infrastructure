#trivy:ignore:AVD-AWS-0066 (LOW): Function does not have tracing enabled.
resource "aws_lambda_function" "earn_aws_credit_invoke_model" {
  function_name = "earn-aws-credit-invoke-model_${data.aws_region.current.region}"
  role          = aws_iam_role.lambda_basic_execution_role.arn

  handler      = "lambda_invoke_model.lambda_handler"
  package_type = "Zip"
  runtime      = "python3.12"
  timeout      = 30

  filename         = data.archive_file.lambda_invoke_model_zip.output_path
  source_code_hash = data.archive_file.lambda_invoke_model_zip.output_base64sha256
}

resource "random_integer" "invoke_model_first_term" {
  min = 0
  max = 9
  keepers = {
    trigger = timestamp()
  }
}

resource "random_integer" "invoke_model_second_term" {
  min = 0
  max = 9
  keepers = {
    trigger = timestamp()
  }
}

resource "aws_lambda_invocation" "invoke_model" {
  function_name = aws_lambda_function.earn_aws_credit_invoke_model.function_name
  input = jsonencode({
    aws_region = data.aws_region.current.region
    model_id   = data.aws_bedrock_foundation_model.nova_pro.model_id
    prompt     = "What is ${random_integer.invoke_model_first_term.result} plus ${random_integer.invoke_model_second_term.result}?  Please answer with a single sentence."
    timestamp  = timestamp()
  })

  triggers = {
    force_reinvoke = timestamp()
  }
}
