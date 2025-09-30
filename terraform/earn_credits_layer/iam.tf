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

resource "aws_iam_role" "lambda_basic_execution_role" {
  name               = "lambda_basic_execution_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {
  role       = aws_iam_role.lambda_basic_execution_role.name
  policy_arn = data.aws_iam_policy.lambda_basic_execution_role.arn
}

resource "aws_iam_role_policy_attachment" "bedrock_full_access_policy" {
  role       = aws_iam_role.lambda_basic_execution_role.name
  policy_arn = data.aws_iam_policy.bedrock_full_access.arn
}
