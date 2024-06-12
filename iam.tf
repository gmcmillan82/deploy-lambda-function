resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = data.aws_iam_policy_document.lambda_policy.json
}
