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

resource "aws_api_gateway_rest_api" "text_api" {
  name        = "TextProcessingAPI"
  description = "API to process text and return the most common words"
}

resource "aws_api_gateway_resource" "text_resource" {
  rest_api_id = aws_api_gateway_rest_api.text_api.id
  parent_id   = aws_api_gateway_rest_api.text_api.root_resource_id
  path_part   = "process-text"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.text_api.id
  resource_id   = aws_api_gateway_resource.text_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.text_api.id
  resource_id             = aws_api_gateway_resource.text_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.process_text.invoke_arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_text.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.text_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]

  rest_api_id = aws_api_gateway_rest_api.text_api.id
  stage_name  = "testing"
}
