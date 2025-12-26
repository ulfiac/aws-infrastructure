resource "aws_iam_role" "lambda_basic_execution_role" {
  name               = "earn-credits-use-foundation-model"
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
