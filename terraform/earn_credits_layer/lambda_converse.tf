data "archive_file" "lambda_converse_zip" {
  output_path = "${path.module}/scripts/lambda_converse.zip"
  source_file = "${path.module}/scripts/lambda_converse.py"
  type        = "zip"
}

#trivy:ignore:AVD-AWS-0066 (LOW): Function does not have tracing enabled.
resource "aws_lambda_function" "earn_aws_credit_converse" {
  function_name = "earn-aws-credit-converse_${var.aws_region}"
  role          = aws_iam_role.lambda_basic_execution_role.arn

  handler      = "lambda_converse.lambda_handler"
  package_type = "Zip"
  runtime      = "python3.12"
  timeout      = 30

  filename         = data.archive_file.lambda_converse_zip.output_path
  source_code_hash = data.archive_file.lambda_converse_zip.output_base64sha256
}

resource "random_integer" "converse_first_term" {
  min = 0
  max = 9
  keepers = {
    trigger = timestamp()
  }
}

resource "random_integer" "converse_second_term" {
  min = 0
  max = 9
  keepers = {
    trigger = timestamp()
  }
}


resource "aws_lambda_invocation" "converse" {
  function_name = aws_lambda_function.earn_aws_credit_converse.function_name
  input = jsonencode({
    # tflint-ignore: terraform_deprecated_interpolation
    aws_region = "${var.aws_region}"
    # tflint-ignore: terraform_deprecated_interpolation
    model_id = "${data.aws_bedrock_foundation_model.nova_pro.model_id}"
    prompt   = "what is ${random_integer.converse_first_term.result} plus ${random_integer.converse_second_term.result}?  Please answer with a single sentence."
    # tflint-ignore: terraform_deprecated_interpolation
    timestamp = "${timestamp()}"
  })

  triggers = {
    force_reinvoke = timestamp()
  }
}
