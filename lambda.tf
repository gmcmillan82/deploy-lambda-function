resource "aws_lambda_function" "process_text" {
  function_name    = "word_list"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  architectures    = ["arm64"]
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.word_list_bucket.bucket
    }
  }
}

resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.process_text.function_name
  authorization_type = "NONE"
}
